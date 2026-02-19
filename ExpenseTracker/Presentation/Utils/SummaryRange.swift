//
//  SummaryRange.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


enum SummaryRange: String, CaseIterable, Identifiable {

    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"

    var id: String { rawValue }
}