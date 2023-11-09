//
//  NotificationView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-08.
//

import Foundation
import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let message: String = "Warning: Hypertensive Crisis"
    
    var body: some View {
        VStack {
            if notificationViewModel.showBanner {
                Text(message)
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Button(action: {
                    notificationViewModel.showBanner = false
                }) {
                    Text("Dismiss")
                        .font(.subheadline)
                        .padding(5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            
            if verticalSizeClass == .regular {
                Image("blood_pressure")
                    .padding(.bottom)
            }
        }
    }
}
