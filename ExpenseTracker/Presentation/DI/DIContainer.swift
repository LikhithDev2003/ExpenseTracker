//
//  Untitled.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

final class DIContainer {
    
    static let shared = DIContainer()
    
    private init(){}
    
    
    lazy var expenseRepo: ExpenseTrackingRepo = ExpenseTrackingRepoImpl()
    
    lazy var createExpenseUseCase = CreateExpenseUseCase(repo: expenseRepo)

    lazy var updateExpenseUseCase = UpdateExpenseUseCase(repo: expenseRepo)

    lazy var deleteExpenseUseCase = DeleteExpensesUseCase(repo: expenseRepo)

    lazy var getExpensesUseCase = GetExpensesUseCase(repo: expenseRepo)
    
    lazy var setBudgetUseCase = SetBudgetUseCase(repo: expenseRepo)
    
    lazy var updateBudgetUseCase = UpdateBudgetUseCase(repo: expenseRepo)
    
    lazy var getBudgetUseCase = GetBudgetUseCase(repo: expenseRepo)
    
    @MainActor
    func makeExpenseTrackingViewModel() -> ExpenseTrackingViewModel {
        return ExpenseTrackingViewModel(
            createExpenseUseCase: createExpenseUseCase,
            updateExpenseUseCase: updateExpenseUseCase,
            deleteExpensesUseCase: deleteExpenseUseCase,
            getExpensesUseCase: getExpensesUseCase,
            setBudgetUseCase: setBudgetUseCase,
            updateBudgetUseCase: updateBudgetUseCase,
            getBudgetUseCase: getBudgetUseCase)
    }


}


