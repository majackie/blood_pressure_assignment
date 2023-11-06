//
//  ReadingItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import SwiftUI

struct ReadingItemView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var isEditing = false
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
                Text("Date: \(viewModel.formatDate(readingItem.createdDate))")
                Spacer()
            }
            
            Button("") {
                isEditing.toggle()
            }
            .sheet(isPresented: $isEditing) {
                EditReadingItemView(viewModel: viewModel, readingItem: readingItem, isEditing: $isEditing)
            }
        }
    }
}
