//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    
    let container = DIContainer.shared

    var body: some Scene {
        WindowGroup {
            MainTabView(viewModel: container.makeExpenseTrackingViewModel())
        }
    }
}
