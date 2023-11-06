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
    @State private var systolic: Double?
    @State private var diastolic: Double?
    
    var body: some View {
        VStack {
            ReadingValueInputView(label: "Systolic", value: $systolic)
            ReadingValueInputView(label: "Diastolic", value: $diastolic)
            
            HStack{
                Button("Save") {
                    if let systolicValue = systolic, let diastolicValue = diastolic {
                        if systolicValue.isNaN || diastolicValue.isNaN {
                            print("Invalid input. Systolic and Diastolic must be valid numbers.")
                        } else {
                            viewModel.addReadingItem(systolic: systolicValue, diastolic: diastolicValue, createdDate: Date.now)
                            viewModel.isAddingReadingItem = false
                            viewModel.fetchReadingItems()
                        }
                    } else {
                        print("Invalid input. Systolic and Diastolic values are required.")
                    }
                }
                .disabled(
                    systolic == nil || diastolic == nil ||
                    systolic!.isNaN || diastolic!.isNaN
                )
                
                Button("Cancel") {
                    viewModel.isAddingReadingItem = false
                }
            }
        }
        .padding()
    }
}
