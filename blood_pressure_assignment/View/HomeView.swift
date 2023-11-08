//
//  HomeView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {                
                NotificationView()
                
                Text("A00889988 | Jackie Ma")
                    .font(.title2)
                
                Spacer()
            }
            .toolbar {
                Text("")
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NotificationViewModel())
}
