//
//  SetBudgetUseCase.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//



import Foundation

final class SetBudgetUseCase {
    private var repo: ExpenseTrackingRepo
    
    init(repo: ExpenseTrackingRepo) {
        self.repo = repo
    }
    
    func invoke(goal: BudgetModel) async throws {
        try await repo.setBudgetGoal(goal: goal)
    }
}
