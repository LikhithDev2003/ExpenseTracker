//
//  DeleteExpensesUseCase.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import Foundation


final class DeleteExpensesUseCase {
    private var repo: ExpenseTrackingRepo
    
    init(repo: ExpenseTrackingRepo) {
        self.repo = repo
    }
    
    func invoke(expenses: [ExpenseModel]) async throws {
        try await repo.deleteExpenses(expenses: expenses)
    }
}