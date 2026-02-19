//
//  SearchBarView.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct SearchBarView: View {

    @Binding var text: String

    var body: some View {

        HStack {

            Image(systemName:"magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search expenses",
                text: $text
            )
        }
        .padding(.horizontal,14)
        .padding(.vertical,12)

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
