//
//  AddReadItemView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import SwiftUI

struct AddReadingItemView: View {
    @ObservedObject var viewModel: DatabaseViewModel
    @ObservedObject var dataViewModel: DataViewModel
    @ObservedObject var reportViewModel: ReportViewModel
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @State var systolic: String = ""
    @State var diastolic: String = ""
    
    var body: some View {
        VStack {
            ReadingItemInputView(label: "Systolic", value: $systolic)
            ReadingItemInputView(label: "Diastolic", value: $diastolic)
            
            HStack {
                Button("Save") {
                    if let systolicValue = Double(systolic), let diastolicValue = Double(diastolic) {
                        if !systolicValue.isNaN && !diastolicValue.isNaN {
                            viewModel.addReadingItem(systolic: systolicValue, diastolic: diastolicValue, createdDate: Date())
                            dataViewModel.isAddingReadingItem.toggle()
                            viewModel.fetchReadingItems()
                            
                            if systolicValue > 180 || diastolicValue > 120 {
                                notificationViewModel.showBanner = true
                            }
                        } else {
                            print("Invalid input. Systolic and Diastolic must be valid numbers.")
                        }
                    } else {
                        print("Invalid input. Systolic and Diastolic values are required.")
                    }
                }
                .disabled(
                    !viewModel.isValidNumber(systolic) || !viewModel.isValidNumber(diastolic)
                )
                
                Button("Cancel") {
                    dataViewModel.isAddingReadingItem.toggle()
                }
            }
        }
        .padding()
    }
}
