//
//  ReadingItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import SwiftUI

struct ReadingItemView: View {
    var readingItem: ReadingItem
    
    var body: some View {
        VStack {
            HStack {
                Text("Systolic: \(String(format: "%.2f", readingItem.systolic)) ")
                Spacer()
                Text("Diastolic: \(String(format: "%.2f", readingItem.diastolic))")
            }
            .listRowSeparator(.hidden)
            HStack {
                Text("Date: \(formatDate(readingItem.createdDate))")
                Spacer()
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        // Implement your date formatting logic here
        return ""
    }
}

