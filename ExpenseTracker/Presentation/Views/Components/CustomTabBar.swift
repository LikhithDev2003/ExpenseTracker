//
//  CustomTabBar.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//


import SwiftUI

struct CustomTabBar: View {

    @Binding var selectedTab: Tab
    @Environment(\.colorScheme) private var colorScheme

    var plusTapped: () -> Void

    var body: some View {

        ZStack {
            HStack {
                tabButton(
                    image: "house",
                    title: "Home",
                    tab: .home
                )

                Spacer()

                tabButton(
                    image: "chart.bar",
                    title: "Summary",
                    tab: .summary
                )
            }
            .padding(.horizontal,40)
            .padding(.top,15)
            .padding(.bottom,25)
            .background(.ultraThinMaterial)

            Button {
                plusTapped()
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundStyle(.background)
                    .frame(
                        width: 70,
                        height: 70
                    )
                    .background(
                        Circle()
                            .fill(colorScheme == .dark ? .white : .black)
                    )
                    .shadow(radius: 8)

            }
            .offset(y:-35)
        }
    }
    
    
    private func tabButton(image: String, title: String, tab: Tab) -> some View {

        Button {
            selectedTab = tab
        } label: {
            VStack(spacing:5) {
                Image(systemName: image)
                    .font(.title2)

                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? (colorScheme == .dark ? .white : .black) : .gray)
        }
    }
}
