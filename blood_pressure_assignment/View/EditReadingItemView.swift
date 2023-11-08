//
//  EditReadingItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-06.
//

import Foundation
import SwiftUI

struct EditReadingItemView: View {
    @ObservedObject var viewModel: DatabaseViewModel
    @Binding var isEditing: Bool
    var readingItem: ReadingItem
    @State var editedSystolic: String = ""
    @State var editedDiastolic: String = ""
    
    init(viewModel: DatabaseViewModel, readingItem: ReadingItem, isEditing: Binding<Bool>) {
        self.viewModel = viewModel
        self.readingItem = readingItem
        self._isEditing = isEditing
        
        _editedSystolic = State(initialValue: String(format: "%.2f", readingItem.systolic))
        _editedDiastolic = State(initialValue: String(format: "%.2f", readingItem.diastolic))
    }
    
    var valuesChanged: Bool {
        return editedSystolic != String(format: "%.2f", readingItem.systolic) || editedDiastolic != String(format: "%.2f", readingItem.diastolic)
    }
    
    var body: some View {
        VStack {
            ReadingItemInputView(label: "Systolic", value: $editedSystolic)
            ReadingItemInputView(label: "Diastolic", value: $editedDiastolic)
            
            HStack {
                Button("Save") {
                    if let systolicValue = Double(editedSystolic), let diastolicValue = Double(editedDiastolic) {
                        if !systolicValue.isNaN && !diastolicValue.isNaN {
                            viewModel.editReadingItem(readingItem, systolic: systolicValue, diastolic: diastolicValue)
                            isEditing.toggle()
                            viewModel.fetchReadingItems()
                        } else {
                            print("Invalid input. Systolic and Diastolic must be valid numbers.")
                        }
                    } else {
                        print("Invalid input. Systolic and Diastolic values are required.")
                    }
                }
                .disabled(
                    !valuesChanged || !viewModel.isValidNumber(editedSystolic) || !viewModel.isValidNumber(editedDiastolic)
                )
                
                Button("Cancel") {
                    isEditing.toggle()
                }
            }
        }
        .padding()
    }
}

