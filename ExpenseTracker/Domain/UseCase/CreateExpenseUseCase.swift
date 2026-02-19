//
//  createExpenseUseCase.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import Foundation

final class CreateExpenseUseCase {
    private var repo: ExpenseTrackingRepo
    
    init(repo: ExpenseTrackingRepo) {
        self.repo = repo
    }
    
    func invoke(expense: ExpenseModel) async throws {
        try await repo.createExpense(expense: expense)
    }
}
