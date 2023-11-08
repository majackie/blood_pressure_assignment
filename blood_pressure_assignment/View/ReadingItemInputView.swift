//
//  ReadingItemInputView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-06.
//

import Foundation
import SwiftUI

struct ReadingItemInputView: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(label + ": ")
            TextField("", text: $value)
                .keyboardType(.decimalPad)
        }
    }
}
