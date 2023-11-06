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
            HStack {
                Text("Systolic: ")
                TextField("", value: $systolic, format: .number)
                    .keyboardType(.decimalPad)
            }
            HStack {
                Text("Diastolic: ")
                TextField("", value: $diastolic, format: .number)
                    .keyboardType(.decimalPad)
            }
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
        }
        .padding()
    }
}
