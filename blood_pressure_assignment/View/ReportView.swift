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
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if notificationViewModel.showBanner {
                    NotificationView(message: "Warning: Reading in Hypertensive Crisis range. Please consult your doctor immediately.", dismissAction: {
                        notificationViewModel.showBanner.toggle()
                    })
                }
                
                Text("Month to Date Average Readings\n")
                    .font(.title2)
                
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
                            Text("Month: " + monthlyAverage.month)
                            Text("Systolic: \(String(format: "%.2f", monthlyAverage.averageSystolic))")
                            Text("Diastolic: \(String(format: "%.2f", monthlyAverage.averageDiastolic))")
                            Text("Average Condition: \(String(monthlyAverage.averageCondition))")
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .toolbar {
                Text("")
                .disabled(viewModel.selectedUserId.isEmpty)
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
        .environmentObject(NotificationViewModel())
}
