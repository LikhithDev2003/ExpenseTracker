//
//  ExpenseTrackingViewModel.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import Foundation
import Combine

@MainActor
final class ExpenseTrackingViewModel: ObservableObject {
    
    private let createExpenseUseCase: CreateExpenseUseCase
    private let updateExpenseUseCase: UpdateExpenseUseCase
    private let deleteExpensesUseCase: DeleteExpensesUseCase
    private let getExpensesUseCase: GetExpensesUseCase
    private let setBudgetUseCase: SetBudgetUseCase
    private let updateBudgetUseCase: UpdateBudgetUseCase
    private let getBudgetUseCase: GetBudgetUseCase
    @Published var expenses: [ExpenseModel] = []
    @Published var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""

    @Published var selectedCategoryFilter: ExpenseCategory? = nil

    @Published private(set) var filteredExpenses: [ExpenseModel] = []
    @Published var budgets: [BudgetModel] = []
    
    
    init(
        createExpenseUseCase: CreateExpenseUseCase,
        updateExpenseUseCase: UpdateExpenseUseCase,
        deleteExpensesUseCase: DeleteExpensesUseCase,
        getExpensesUseCase: GetExpensesUseCase,
        setBudgetUseCase: SetBudgetUseCase,
        updateBudgetUseCase: UpdateBudgetUseCase,
        getBudgetUseCase: GetBudgetUseCase
    ) {
        self.createExpenseUseCase = createExpenseUseCase
        self.updateExpenseUseCase = updateExpenseUseCase
        self.deleteExpensesUseCase = deleteExpensesUseCase
        self.getExpensesUseCase = getExpensesUseCase
        self.setBudgetUseCase = setBudgetUseCase
        self.updateBudgetUseCase = updateBudgetUseCase
        self.getBudgetUseCase = getBudgetUseCase
        fetchAndObserveExpenses()
        loadBudgetGoals()
        setupFiltering()
    }
    
    
    
    func createExpense(name: String,amount: String,category: ExpenseCategory?, date: Date, recurrence: ExpenseRecurrence, onSuccess: @escaping () -> Void
    ) {

        guard !name.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {

            errorMessage = "Expense name required"
            return
        }

        guard let amountValue =
            Double(amount) else {

            errorMessage = "Invalid amount"
            return
        }

        guard let category else {

            errorMessage = "Select category"
            return
        }

        let expense = ExpenseModel(
            id: UUID(),
            name: name,
            amount: amountValue,
            category: category.rawValue,
            timeStamp: date,
            isRecurring: recurrence != .never,
            recurrance: recurrence.rawValue
        )

        Task {
            do {
                try await createExpenseUseCase.invoke(expense: expense)
                onSuccess()
            } catch {
                handleErrors(error)
            }
        }
    }
    
    
    
    func fetchAndObserveExpenses() {
        Task {
            do {

                let publisher =
                try await getExpensesUseCase.invoke()

                publisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] expenses in
                        self?.expenses = expenses
                    }
                    .store(in: &cancellables)

            } catch {
                handleErrors(error)
            }
        }
    }
    
    
    func updateExpense(
        expenseID: UUID,
        name: String,
        amount: String,
        category: ExpenseCategory?,
        date: Date,
        recurrence: ExpenseRecurrence,
        onSuccess:@escaping ()->Void
    ) {

        guard let amountValue =
        Double(amount),
        let category else {

            errorMessage =
            "Invalid Input"

            return
        }

        let expense = ExpenseModel(

            id: expenseID,

            name: name,

            amount: amountValue,

            category:
            category.rawValue,

            timeStamp: date,

            isRecurring:
            recurrence != .never,

            recurrance:
            recurrence.rawValue
        )

        Task {

            do {

                try await
                updateExpenseUseCase
                    .invoke(expense: expense)

                onSuccess()

            } catch {

                handleErrors(error)
            }
        }
    }
    
    
    func deleteExpense(_ expense: ExpenseModel) {

        Task {

            do {

                try await deleteExpensesUseCase
                    .invoke(expenses: [expense])

            } catch {

                handleErrors(error)
            }
        }
    }
    
    
    private func setupFiltering() {

        Publishers.CombineLatest3(

            $expenses,

            $searchText,

            $selectedCategoryFilter
        )
        .map { expenses,
               searchText,
               category in

            expenses.filter {

                expense in

                let matchesSearch =

                searchText.isEmpty ||

                expense.name
                    .localizedCaseInsensitiveContains(
                        searchText
                    )

                let matchesCategory =

                category == nil ||

                expense.category ==
                category?.rawValue

                return matchesSearch
                &&
                matchesCategory
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$filteredExpenses)
    }
    
    
    func setBudgetGoal(
        amount: String,
        date: Date,
        onSuccess: @escaping () -> Void
    ) {

        guard let value =
        Double(amount),
        value > 0 else {

            errorMessage =
            "Invalid budget amount"

            return
        }

        let budget = BudgetModel(timeStamp: date, amount: value)

        Task {
            do {
                try await setBudgetUseCase.invoke(goal: budget)
                await fetchBudgetGoals()
                onSuccess()
            } catch {
                handleErrors(error)
            }
        }
    }
    
    
    
    func fetchBudgetGoals() async {

        do {
            let result =
            try await
            getBudgetUseCase.invoke()
            self.budgets = result
        } catch {
            handleErrors(error)
        }
    }
    
    func loadBudgetGoals() {

        Task {
            await fetchBudgetGoals()
        }
    }
    
    
    func generateRecurringExpenses() {

        let calendar = Calendar.current
        let now = Date()
        let recurringExpenses =
        expenses.filter {

            $0.isRecurring
        }

        for recurring in recurringExpenses {
            let alreadyCreated =
            expenses.contains {

                existing in

                // same recurring template
                existing.name == recurring.name &&
                existing.category == recurring.category &&
                existing.isRecurring &&

                isSamePeriod(
                    recurring.recurrance,
                    existingDate: existing.timeStamp,
                    today: now,
                    calendar: calendar
                )
            }

            if alreadyCreated { continue }

            let newExpense = ExpenseModel(
                id: UUID(),
                name: recurring.name,
                amount: recurring.amount,
                category: recurring.category,
                timeStamp: now,
                isRecurring: true,
                recurrance: recurring.recurrance
            )

            Task {
                try? await createExpenseUseCase
                    .invoke(expense: newExpense)
            }
        }
    }
    
    
    private func isSamePeriod(
        _ recurrence: String,
        existingDate: Date,
        today: Date,
        calendar: Calendar
    ) -> Bool {

        switch recurrence {

        case "Daily":

            return calendar.isDate(
                existingDate,
                inSameDayAs: today
            )

        case "Weekly":

            return calendar.isDate(
                existingDate,
                equalTo: today,
                toGranularity: .weekOfYear
            )

        case "Monthly":

            return calendar.isDate(
                existingDate,
                equalTo: today,
                toGranularity: .month
            )

        default:

            return false
        }
    }
    
    
    private func handleErrors(_ error: Error) {
        if let error = error as? DBError {
            errorMessage = error.description
        } else {
            errorMessage = error.localizedDescription
        }
    }


}
