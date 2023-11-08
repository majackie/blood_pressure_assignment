//
//  ReadingItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import SwiftUI

struct ReadingItemView: View {
    @ObservedObject var viewModel: DatabaseViewModel
    @State var isEditing = false
    var readingItem: ReadingItem
    
    var body: some View {
        VStack {
            Button {
                isEditing.toggle()
            } label: {
                HStack {
                    Text("Systolic: \(String(format: "%.2f", readingItem.systolic))")
                        .foregroundColor(.black)
                    Spacer()
                    Text("Diastolic: \(String(format: "%.2f", readingItem.diastolic))")
                        .foregroundColor(.black)
                }
                .listRowSeparator(.hidden)
                
                HStack {
                    Text("Date: \(viewModel.formatDate(readingItem.createdDate))")
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .sheet(isPresented: $isEditing) {
                EditReadingItemView(viewModel: viewModel, readingItem: readingItem, isEditing: $isEditing)
            }
        }
    }
}
