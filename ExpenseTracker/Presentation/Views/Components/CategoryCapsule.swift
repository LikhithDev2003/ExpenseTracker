//
//  CategoryCapsule.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct CategoryCapsule: View {

    let category: ExpenseCategory

    let isSelected: Bool

    var onTap: () -> Void

    var body: some View {

        Button {
            onTap()
        } label: {
            Text(category.rawValue)
                .font(.subheadline)
                .padding(.horizontal,18)
                .padding(.vertical,10)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                            ? Color.primary
                            : Color.clear
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(
                            Color.primary.opacity(0.4),
                            lineWidth: 1
                        )
                )
                .foregroundStyle(
                    isSelected
                    ? Color(.systemBackground)
                    : .primary
                )
        }
    }
}
