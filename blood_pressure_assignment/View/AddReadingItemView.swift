//
//  AddReadItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import SwiftUI

struct AddReadingItemView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var systolic: String = ""
    @State var diastolic: String = ""
    
    var body: some View {
        VStack {
            ReadingValueInputView(label: "Systolic", value: $systolic)
            ReadingValueInputView(label: "Diastolic", value: $diastolic)
            
            HStack {
                Button("Save") {
                    if let systolicValue = Double(systolic), let diastolicValue = Double(diastolic) {
                        if !systolicValue.isNaN && !diastolicValue.isNaN {
                            viewModel.addReadingItem(systolic: systolicValue, diastolic: diastolicValue, createdDate: Date())
                            viewModel.isAddingReadingItem = false
                            viewModel.fetchReadingItems()
                        } else {
                            print("Invalid input. Systolic and Diastolic must be valid numbers.")
                        }
                    } else {
                        print("Invalid input. Systolic and Diastolic values are required.")
                    }
                }
                .disabled(
                    !isValidNumber(systolic) || !isValidNumber(diastolic)
                )
                
                Button("Cancel") {
                    viewModel.isAddingReadingItem = false
                }
            }
        }
        .padding()
    }
    
    func isValidNumber(_ value: String) -> Bool {
        return Double(value) != nil
    }
}
