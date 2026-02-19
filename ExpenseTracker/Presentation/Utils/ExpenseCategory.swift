//
//  ExpenseCategory.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import SwiftUICore

enum ExpenseCategory: String, CaseIterable, Identifiable {

    case travel = "Travel"
    case food = "Food"
    case utilities = "Utilities"
    case others = "Others"

    var id: String { rawValue }
    
    static var orderedCases:[ExpenseCategory] {
        [
            .travel,
            .food,
            .utilities,
            .others
        ]
    }
    
    var color: Color {

        switch self {

        case .travel:
            return .blue

        case .food:
            return .orange

        case .utilities:
            return .yellow

        case .others:
            return .gray
        }
    }

}
