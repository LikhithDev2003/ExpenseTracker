//
//  ChartItem.swift
//  ExpenseTracker
//
//  Created by Likhith Undabhatla on 19/02/26.
//

import Foundation


struct ChartItem: Identifiable {
    let id = UUID()
    let label: String
    let amount: Double
}
