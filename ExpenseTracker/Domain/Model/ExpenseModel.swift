//
//  ExpenseModel.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import Foundation


struct ExpenseModel: Identifiable {
    let id: UUID
    let name: String
    let amount: Double
    let category: String
    let timeStamp: Date
    let isRecurring: Bool
    let recurrance: String
}
