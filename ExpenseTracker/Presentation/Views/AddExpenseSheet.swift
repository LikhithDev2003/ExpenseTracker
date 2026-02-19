//
//  AddExpenseSheet.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct AddExpenseSheet: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var expenseName = ""
    @State private var amount = ""
    @State private var selectedCategory: ExpenseCategory?
    @State private var selectedDateTime: Date = Date()
    @State private var recurrence: ExpenseRecurrence = .never
    @ObservedObject var viewModel: ExpenseTrackingViewModel
    let expense: ExpenseModel?

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 25) {

                RoundedInputField(
                    title: "Expense",
                    placeholder: "Expense",
                    text: $expenseName
                )

                RoundedInputField(
                    title: "Amount",
                    placeholder: "Enter Amount",
                    text: $amount,
                    keyboardType: .decimalPad
                )
                
                
                Text("Categories")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ExpenseCategory.allCases) { category in
                            CategoryCapsule(category: category,isSelected : selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.vertical,5)
                }
                
                HStack {
                    Text("Date & Time")
                        .font(.headline)
                    
                    Spacer()
                    
                    DatePicker(
                        "",
                        selection: $selectedDateTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
                

                HStack {
                    Text("Recurrence")
                        .font(.headline)

                    Spacer()

                    Menu {
                        ForEach(
                            ExpenseRecurrence.allCases
                        ) { option in

                            Button(option.rawValue) {

                                recurrence = option
                            }
                        }
                    } label: {
                        HStack(spacing:6) {
                            Text(recurrence.rawValue)

                            Image(systemName:"chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal,16)
                        .padding(.vertical,10)
                        .background(
                            Capsule()
                                .stroke(
                                    Color.primary.opacity(0.3)
                                )
                        )
                    }
                }


                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading
                ) {
                    Button {
                        dismiss()
                    } label: {
                        Image(
                            systemName:"xmark"
                                
                        )
                        .fontWeight(.bold)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                }


                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button {
                        if let expense {

                            viewModel.updateExpense(
                                expenseID: expense.id,
                                name: expenseName,
                                amount: amount,
                                category: selectedCategory,
                                date: selectedDateTime,
                                recurrence: recurrence
                            ) {
                                dismiss()
                            }

                        } else {

                            viewModel.createExpense(
                                name: expenseName,
                                amount: amount,
                                category: selectedCategory,
                                date: selectedDateTime,
                                recurrence: recurrence
                            ) {
                                dismiss()
                            }
                        }
                    } label: {
                        Image(
                            systemName:"checkmark"
                        )
                        .fontWeight(.bold)
                        .foregroundStyle(Color.green)
                    }
                }
            }
            .onAppear {

                guard let expense else { return }

                expenseName = expense.name

                amount = String(expense.amount)

                selectedCategory =
                ExpenseCategory(
                    rawValue: expense.category
                )

                selectedDateTime =
                expense.timeStamp

                recurrence =
                ExpenseRecurrence(
                    rawValue:
                    expense.recurrance
                ) ?? .never
            }
        }
        .presentationDetents([.fraction(0.75)])
        .presentationDragIndicator(.visible)
    }
}
