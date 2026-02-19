//
//  MainTabView.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import SwiftUI


struct MainTabView: View {
    
    @State private var selectedTab: Tab = .home
    @StateObject var viewModel: ExpenseTrackingViewModel
    @State private var showAddExpenseSheet = false
    @State private var showErrorAlert = false
    init(viewModel: ExpenseTrackingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {

                switch selectedTab {

                case .home:
                    HomeView(viewModel: viewModel)

                case .summary:
                    SummaryView(viewModel: viewModel)
                }
            }

            CustomTabBar(
                selectedTab: $selectedTab
            ) {
                showAddExpenseSheet = true
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddExpenseSheet) {
            AddExpenseSheet(viewModel: viewModel, expense: nil)
        }
        .onAppear {
            viewModel.generateRecurringExpenses()
        }
        .onReceive(
            viewModel.$errorMessage
        ) { message in

            showErrorAlert =
            !message.isEmpty
        }
        .alert(
            "Error", isPresented: $showErrorAlert
        ) {
            Button("OK") {
                viewModel.errorMessage = ""
            }
        } message: {
            Text(viewModel.errorMessage)
        }

    }
}


enum Tab {
    case home
    case summary
}
