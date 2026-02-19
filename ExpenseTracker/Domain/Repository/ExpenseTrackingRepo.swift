//
//  ExpenseTrackingRepo.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import Foundation
import Combine

protocol ExpenseTrackingRepo {
    
    func createExpense(expense: ExpenseModel) async throws
    
    func fetchExpenses() async throws -> AnyPublisher<[ExpenseModel], Never>
    
    func updateExpense(expense: ExpenseModel) async throws
    
    func deleteExpenses(expenses: [ExpenseModel]) async throws
    
    func setBudgetGoal(goal: BudgetModel) async throws
    
    func getBudgetGoals() async throws -> [BudgetModel]
    
    func updateBudgetGoal(goal: BudgetModel) async throws
}
