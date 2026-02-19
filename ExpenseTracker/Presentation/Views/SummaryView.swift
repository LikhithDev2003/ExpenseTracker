//
//  SummaryView.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import SwiftUI
import CoreData
import Charts

struct SummaryView: View {
    
    @ObservedObject var viewModel: ExpenseTrackingViewModel
    @State private var selectedRange:
    SummaryRange = .daily
    @State private var showBudgetPopup = false
    @State private var budgetAmount = ""
    
    
    var body: some View {
        VStack(spacing:20) {
            
            Picker(
                "",
                selection: $selectedRange
            ) {
                
                ForEach(
                    SummaryRange.allCases
                ) { range in
                    
                    Text(range.rawValue)
                        .tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
                        
            ScrollView(showsIndicators: false) {
                
                Chart(chartData) { item in
                    
                    BarMark(
                        x: .value(
                            "Category",
                            item.label
                        ),
                        
                        y: .value(
                            "Amount",
                            item.amount
                        )
                    )
                    .foregroundStyle(

                        ExpenseCategory(
                            rawValue: item.label
                        )?.color ?? .gray
                    )
                }
                .frame(height:300)
                .padding()
                
                Spacer().frame(height: 50)
                
                if let budget = viewModel.budgets.first {

                    BudgetCardView(

                        budget: budget,

                        expenses:
                        viewModel.expenses,

                        selectedRange:
                        selectedRange
                    )
                } else {
                    Button {
                        showBudgetPopup = true
                    } label: {

                        Text("Set Budget Goal")
                            .fontWeight(.semibold)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(
                                RoundedRectangle(
                                    cornerRadius:14
                                )
                                .fill(.blue)
                            )
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
                
            }
        }
        .alert(
            "Set Budget Goal",
            isPresented: $showBudgetPopup
        ) {

            TextField(
                "Enter Amount",
                text: $budgetAmount
            )
            .keyboardType(.decimalPad)

            Button("Cancel",
                   role: .cancel) {}

            Button("Save") {

                viewModel.setBudgetGoal(

                    amount: budgetAmount,

                    date: Date()

                ) {

                    budgetAmount = ""
                }
            }

        } message: {

            Text("Enter your budget amount.")
        }
        .background(
            Color(.systemBackground)
        )
    }
    
    
    private var chartData: [ChartItem] {

        let filteredExpenses =
        filterExpensesByRange()

        let grouped =
        Dictionary(
            grouping: filteredExpenses
        ) {

            $0.category
        }

        return ExpenseCategory
            .orderedCases
            .map { category in

                let expenses =
                grouped[
                    category.rawValue
                ] ?? []

                let total =
                expenses.reduce(0) {
                    $0 + $1.amount
                }

                return ChartItem(
                    label:
                    category.rawValue,
                    amount:
                    total
                )
            }
    }
    
    
    private func filterExpensesByRange()
    -> [ExpenseModel] {
        
        let calendar =
        Calendar.current
        
        switch selectedRange {
            
        case .daily:
            
            return viewModel.expenses.filter {
                
                calendar.isDateInToday(
                    $0.timeStamp
                )
            }
            
        case .weekly:
            
            return viewModel.expenses.filter {
                
                calendar.isDate(
                    $0.timeStamp,
                    equalTo: Date(),
                    toGranularity:
                            .weekOfYear
                )
            }
            
        case .monthly:
            
            return viewModel.expenses.filter {
                
                calendar.isDate(
                    $0.timeStamp,
                    equalTo: Date(),
                    toGranularity:
                            .month
                )
            }
        }
    }
}
