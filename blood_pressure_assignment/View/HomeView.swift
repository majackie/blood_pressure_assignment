//
//  HomeView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ZStack {
            VStack {
                if verticalSizeClass == .regular {
                    Image("blood_pressure")
                        .padding(.bottom)
                }
                
                Text("A00889988 | Jackie Ma")
            }
        }
    }
}

#Preview {
    HomeView()
}
