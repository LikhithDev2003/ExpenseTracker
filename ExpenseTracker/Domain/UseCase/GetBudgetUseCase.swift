//
//  GetBudgetUseCase.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import Foundation

final class GetBudgetUseCase {
    private var repo: ExpenseTrackingRepo
    
    init(repo: ExpenseTrackingRepo) {
        self.repo = repo
    }
    
    func invoke() async throws -> [BudgetModel] {
        try await repo.getBudgetGoals()
    }
}
