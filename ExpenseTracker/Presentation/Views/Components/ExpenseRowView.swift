//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct ExpenseRowView: View {

    let expense: ExpenseModel

    var body: some View {

        HStack {
            
            VStack(alignment: .leading,
                   spacing: 6) {

                Text(expense.name)
                    .font(.headline)

                Text(expense.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(
                    expense.timeStamp,
                    style: .date
                )
                .font(.caption2)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text(
                expense.amount,
                format:
                .currency(
                    code: "INR"
                )
            )
            .font(.headline)
            .fontWeight(.semibold)
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(Color(.secondarySystemBackground))
        )
    }
}
