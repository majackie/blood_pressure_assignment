//
//  ContentView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ChartView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Chart")
                }
            AboutView()
                .tabItem {
                    Image(systemName: "person")
                    Text("About")
                }
        }
    }
}

#Preview {
    ContentView()
}
