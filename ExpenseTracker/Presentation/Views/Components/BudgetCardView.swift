//
//  BudgetCardView.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct BudgetCardView: View {

    let budget: BudgetModel

    let expenses: [ExpenseModel]

    let selectedRange: SummaryRange

    var body: some View {

        VStack(alignment:.leading,
               spacing:15) {

            Text(
                "\(selectedRange.rawValue) Budget"
            )
            .font(.headline)

            Divider()

            HStack {

                VStack(alignment:.leading,
                       spacing:8){

                    Text(
                        remainingText()
                    )
                    .foregroundStyle(
                        remainingColor()
                    )

                    Text(
                        "Spent ₹\(spent(),specifier:"%.0f")"
                    )
                    .font(.caption)
                }

                Spacer()

                Text(

                "₹\(spent(),specifier:"%.0f") / ₹\(limit(),specifier:"%.0f")"

                )
                .fontWeight(.semibold)
            }
        }
        .padding()

        .background(

            RoundedRectangle(
                cornerRadius:16
            )
            .fill(
                Color(
                .secondarySystemBackground
                )
            )
        )
        .padding(.horizontal)
    }
    
    func limit() -> Double {

        switch selectedRange {

        case .daily:

            let days =
            Calendar.current
                .range(
                    of:.day,
                    in:.month,
                    for:Date()
                )?.count ?? 30

            return budget.amount /
            Double(days)

        case .weekly:

            return budget.amount / 4

        case .monthly:

            return budget.amount
        }
    }

    
    func spent() -> Double {

        let calendar =
        Calendar.current

        let filtered:

        [ExpenseModel]

        switch selectedRange {

        case .daily:

            filtered =
            expenses.filter {

                calendar.isDateInToday(
                    $0.timeStamp
                )
            }

        case .weekly:

            filtered =
            expenses.filter {

                calendar.isDate(
                    $0.timeStamp,
                    equalTo: Date(),
                    toGranularity:
                    .weekOfYear
                )
            }

        case .monthly:

            filtered =
            expenses.filter {

                calendar.isDate(
                    $0.timeStamp,
                    equalTo: Date(),
                    toGranularity:
                    .month
                )
            }
        }

        return filtered.reduce(0){

            $0 + $1.amount
        }
    }
    
    
    func remainingText() -> String {

        let remaining =
        limit() - spent()

        if remaining >= 0 {

            return
            "₹\(String(format: "%.0f", remaining)) left"

        } else {

            return
            "Exceeded ₹\(String(format: "%.0f", -remaining))"
        }
    }
    
    func remainingColor() -> Color {

        (limit() - spent()) >= 0
        ? .green
        : .red
    }
}
