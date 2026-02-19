//
//  ExpenseTrackingRepoImpl.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import Foundation
import Combine
import CoreData


final class ExpenseTrackingRepoImpl: ExpenseTrackingRepo {
    
    
    private var expensePublisher: FetchedResultsPublisher<ExpenseEntity>?
    
    func createExpense(expense: ExpenseModel) async throws {
        
        let context = PersistenceController.shared.container.newBackgroundContext()

        try await context.perform {

            let entity = ExpenseEntity(context: context)

            entity.id = expense.id
            entity.name = expense.name
            entity.amount = expense.amount
            entity.category = expense.category
            entity.isRecurring = expense.isRecurring
            entity.recurrance = expense.recurrance
            entity.timeStamp = expense.timeStamp

            do {
                try context.save()
            } catch {
                throw DBError.saveFailed(error.localizedDescription)
            }
        }

    }
    
    
    func fetchExpenses() async throws -> AnyPublisher<[ExpenseModel], Never> {
        
        let context = PersistenceController.shared.container.viewContext
        
        let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        let publisher = FetchedResultsPublisher(fetchRequest: request, context: context)
        self.expensePublisher = publisher
        
        return publisher
            .map { entities in
                entities.map {
                    ExpenseModel(
                        id: $0.id ?? UUID(),
                        name: $0.name ?? "",
                        amount: $0.amount,
                        category: $0.category ?? "",
                        timeStamp: $0.timeStamp ?? Date(),
                        isRecurring: $0.isRecurring,
                        recurrance: $0.recurrance ?? ""
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func updateExpense(expense: ExpenseModel) async throws {
        let context = PersistenceController.shared.container.newBackgroundContext()

        try await context.perform {
            
            let request: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
            
            request.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)

            request.fetchLimit = 1

            do {

                guard let entity = try context.fetch(request).first else {
                    throw DBError.updateFailed("Expense not found")
                }

                entity.name = expense.name
                entity.amount = expense.amount
                entity.category = expense.category
                entity.isRecurring = expense.isRecurring
                entity.recurrance = expense.recurrance
                entity.timeStamp = expense.timeStamp

                try context.save()

            } catch {
                throw DBError.updateFailed(error.localizedDescription)
            }

        }
        
    }
    
    func deleteExpenses(expenses: [ExpenseModel]) async throws {
        let context = PersistenceController.shared.container.newBackgroundContext()

        try await context.perform {

            let ids = expenses.map { $0.id }

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExpenseEntity.fetchRequest()

            fetchRequest.predicate = NSPredicate(format: "id IN %@",ids)

            let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)

            deleteRequest.resultType = .resultTypeObjectIDs

            do {

                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult

                if let objectIDs = result?.result as? [NSManagedObjectID] {

                    let changes = [NSDeletedObjectsKey: objectIDs]

                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: changes,
                        into: [
                            PersistenceController.shared.container.viewContext
                        ]
                    )
                }

            } catch {
                throw DBError.deleteFailed(error.localizedDescription)
            }
        }

    }
    
    func setBudgetGoal(goal: BudgetModel) async throws {

        let context = PersistenceController.shared.container.newBackgroundContext()

        try await context.perform {

            let request: NSFetchRequest<BudgetEntity> = BudgetEntity.fetchRequest()

            request.predicate = NSPredicate(format: "timeStamp == %@", goal.timeStamp as NSDate)

            request.fetchLimit = 1

            do {

                let existing = try context.fetch(request).first

                if existing != nil {
                    throw DBError.saveFailed("Budget already exists")
                }

                let entity = BudgetEntity(context: context)

                entity.timeStamp = goal.timeStamp
                entity.amount = goal.amount

                try context.save()

            } catch {
                throw DBError.saveFailed(error.localizedDescription)
            }
        }
    }
    
    func getBudgetGoals() async throws -> [BudgetModel] {

        let context = PersistenceController.shared.container.viewContext

        return try await context.perform {

            let request: NSFetchRequest<BudgetEntity> = BudgetEntity.fetchRequest()

            request.sortDescriptors = [NSSortDescriptor( key: "timeStamp",  ascending: false  )]

            do {

                let results =
                try context.fetch(request)

                return results.map {

                    BudgetModel(timeStamp: $0.timeStamp ?? Date(), amount: $0.amount)
                }

            } catch {

                throw DBError.fetchFailed(error.localizedDescription)
            }
        }
    }
    
    func updateBudgetGoal(goal: BudgetModel) async throws {

        let context = PersistenceController.shared.container.newBackgroundContext()

        try await context.perform {

            let request: NSFetchRequest<BudgetEntity> = BudgetEntity.fetchRequest()

            request.predicate = NSPredicate(format: "timeStamp == %@", goal.timeStamp as NSDate)

            request.fetchLimit = 1

            do {

                guard let entity = try context.fetch(request).first else {

                    throw DBError.updateFailed("Budget not found")
                }

                entity.amount = goal.amount
                try context.save()

            } catch {

                throw DBError.updateFailed(error.localizedDescription)
            }
        }
    }
    
}
