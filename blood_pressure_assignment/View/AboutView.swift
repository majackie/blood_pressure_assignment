//
//  AboutView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct AboutView: View {
    @StateObject var viewModel = AboutViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("A00889988 | Jackie Ma")
            }
        }
    }
}

#Preview {
    AboutView()
}
