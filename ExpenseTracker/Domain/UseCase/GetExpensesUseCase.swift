//
//  GetExpensesUseCase.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import Foundation
import Combine

final class GetExpensesUseCase {
    private var repo: ExpenseTrackingRepo
    
    init(repo: ExpenseTrackingRepo) {
        self.repo = repo
    }
    
    func invoke() async throws -> AnyPublisher<[ExpenseModel], Never> {
        try await repo.fetchExpenses()
    }
}