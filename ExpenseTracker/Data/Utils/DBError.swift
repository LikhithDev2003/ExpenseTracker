//
//  DBErros.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//
import Foundation


enum DBError: Error {
    case saveFailed(String)
    case fetchFailed(String)
    case deleteFailed(String)
    case updateFailed(String)
    case unknown(String)
    
    var description: String {
        switch self {
        case .saveFailed(let e):
            return "Failed to save to DB: \(e)"
        case .fetchFailed(let e):
            return "Failed to fetch from DB: \(e)"
        case .deleteFailed(let e):
            return "Failed to delete from DB: \(e)"
        case .updateFailed(let e):
            return "Failed to update to DB: \(e)"
        case .unknown(let e):
            return "unknown error: \(e)"
        }
    }
}
