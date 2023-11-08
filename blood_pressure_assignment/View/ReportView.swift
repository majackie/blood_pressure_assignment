//
//  ReportView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct ReportView: View {
    @StateObject var viewModel = DatabaseViewModel()
    @StateObject var reportViewModel = ReportViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("User ID: \(viewModel.selectedUserId)")
                
                Picker("Select a Family Member", selection: $viewModel.selectedUserId) {
                    ForEach(viewModel.users, id: \.id!) { user in
                        Text(user.name)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectedUserId) { newValue, _ in
                    viewModel.fetchReadingItems()
                }
                
                List {
                    let readingItems: [ReadingItem] = viewModel.readingItems
                    ForEach(reportViewModel.calculateMonthlyAverages(readingItems: readingItems), id: \.month) { monthlyAverage in
                        VStack(alignment: .leading) {
                            Text("MTD avg readings for " + monthlyAverage.month)
                                .fontWeight(.bold)
                            Text("Systolic Reading: \(String(format: "%.2f", monthlyAverage.averageSystolic))")
                            Text("Diastolic Reading: \(String(format: "%.2f", monthlyAverage.averageDiastolic))")
                            Text("Average Condition: \(String(monthlyAverage.averageCondition))")
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    ReportView()
}
