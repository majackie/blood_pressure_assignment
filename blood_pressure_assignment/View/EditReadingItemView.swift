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
    @State var editedSystolic: String = ""
    @State var editedDiastolic: String = ""
    
    init(viewModel: HomeViewModel, readingItem: ReadingItem, isEditing: Binding<Bool>) {
        self.viewModel = viewModel
        self.readingItem = readingItem
        self._isEditing = isEditing
        
        _editedSystolic = State(initialValue: String(readingItem.systolic))
        _editedDiastolic = State(initialValue: String(readingItem.diastolic))
    }
    
    var valuesChanged: Bool {
        return editedSystolic != String(readingItem.systolic) || editedDiastolic != String(readingItem.diastolic)
    }
    
    var body: some View {
        VStack {
            ReadingValueInputView(label: "Systolic", value: $editedSystolic)
            ReadingValueInputView(label: "Diastolic", value: $editedDiastolic)
            
            HStack {
                Button("Save") {
                    if let systolicValue = Double(editedSystolic), let diastolicValue = Double(editedDiastolic) {
                        if !systolicValue.isNaN && !diastolicValue.isNaN {
                            viewModel.editReadingItem(readingItem, systolic: systolicValue, diastolic: diastolicValue)
                            isEditing = false
                            viewModel.fetchReadingItems()
                        } else {
                            print("Invalid input. Systolic and Diastolic must be valid numbers.")
                        }
                    } else {
                        print("Invalid input. Systolic and Diastolic values are required.")
                    }
                }
                .disabled(
                    !valuesChanged || !isValidNumber(editedSystolic) || !isValidNumber(editedDiastolic)
                )
                
                Button("Cancel") {
                    isEditing = false
                }
            }
        }
        .padding()
    }
    
    func isValidNumber(_ value: String) -> Bool {
        return Double(value) != nil
    }
}

