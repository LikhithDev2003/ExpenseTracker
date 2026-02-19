//
//  RoundedInputField.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct RoundedInputField: View {

    let title: String
    let placeholder: String

    @Binding var text: String

    var keyboardType: UIKeyboardType = .default

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.horizontal,20)
                .padding(.vertical,12)
                .background(

                    Capsule()
                        .strokeBorder(
                            Color.primary.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
    }
}
