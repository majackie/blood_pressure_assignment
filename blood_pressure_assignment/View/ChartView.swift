//
//  ChartView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct ChartView: View {
    @StateObject var viewModel = AboutViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Chart")
        }
        .padding()
    }
}

#Preview {
    ChartView()
}
