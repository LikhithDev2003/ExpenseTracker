//
//  ExpenseRecurrence.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


enum ExpenseRecurrence: String, CaseIterable, Identifiable {

    case never = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"

    var id: String { rawValue }
}