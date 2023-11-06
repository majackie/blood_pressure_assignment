//
//  EditReadingItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-06.
//

import Foundation
import SwiftUI

struct EditReadingItemView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isEditing: Bool
    var readingItem: ReadingItem
    @State private var editedSystolic: Double?
    @State private var editedDiastolic: Double?
    
    init(viewModel: HomeViewModel, readingItem: ReadingItem, isEditing: Binding<Bool>) {
        self.viewModel = viewModel
        self.readingItem = readingItem
        self._isEditing = isEditing
        
        _editedSystolic = State(initialValue: readingItem.systolic)
        _editedDiastolic = State(initialValue: readingItem.diastolic)
    }
    
    var body: some View {
        VStack {
            ReadingValueInputView(label: "Systolic", value: $editedSystolic)
            ReadingValueInputView(label: "Diastolic", value: $editedDiastolic)
            
            Button("Save") {
                if let systolicValue = editedSystolic, let diastolicValue = editedDiastolic {
                    if systolicValue.isNaN || diastolicValue.isNaN {
                        print("Invalid input. Systolic and Diastolic must be valid numbers.")
                    } else {
                        viewModel.editReadingItem(readingItem, systolic: systolicValue, diastolic: diastolicValue)
                        isEditing = false
                        viewModel.fetchReadingItems()
                    }
                } else {
                    print("Invalid input. Systolic and Diastolic values are required.")
                }
            }
            .disabled(
                editedSystolic == nil || editedDiastolic == nil ||
                editedSystolic!.isNaN || editedDiastolic!.isNaN
            )
        }
        .padding()
    }
}
