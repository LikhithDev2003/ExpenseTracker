//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @ObservedObject var viewModel: ExpenseTrackingViewModel
    @State private var selectedExpense: ExpenseModel?

    var body: some View {
        VStack {
            HStack(spacing:10) {

                SearchBarView(
                    text:
                    $viewModel.searchText
                )
                Menu {
                    Button("All") {
                        viewModel.selectedCategoryFilter = nil
                    }
                    ForEach(
                        ExpenseCategory.allCases
                    ) { category in
                        Button(
                            category.rawValue
                        ) {
                            viewModel.selectedCategoryFilter = category
                        }
                    }
                } label: {
                    Image(
                     systemName:"line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .padding(10)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(
                            Color(
                             .secondarySystemBackground
                            )
                        )
                    )
                }
            }
            .padding(.horizontal)

            
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredExpenses,id: \.id) { expense in
                        ExpenseRowView(
                            expense: expense
                        )
                        .onTapGesture {
                            selectedExpense = expense
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.deleteExpense(expense)

                            } label: {
                                Label(
                                    "Delete",
                                    systemImage: "trash"
                                )
                            }
                        }
                    }
                }
                .padding()
                
            }
            
        }
        .sheet(item: $selectedExpense) { expense in
            AddExpenseSheet(viewModel: viewModel, expense: expense)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
