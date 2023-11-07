//
//  ReadingValueInputView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-06.
//

import Foundation
import SwiftUI

struct ReadingValueInputView: View {
    let label: String
    @Binding var value: Double?
    
    var body: some View {
        HStack {
            Text(label + ": ")
            TextField("", value: $value, format: .number)
                .keyboardType(.decimalPad)
        }
    }
}