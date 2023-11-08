//
//  NotificationView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-08.
//

import Foundation
import SwiftUI

struct NotificationView: View {
    let message: String
    let dismissAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            Button(action: {
                dismissAction()
            }) {
                Text("Dismiss")
                    .font(.subheadline)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding()
    }
}
