//
//  ReportView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI

struct ReportView: View {
    @StateObject var viewModel = DatabaseViewModel()
    
    struct MonthlyAverage {
        let month: String
        let averageSystolic: Double
        let averageDiastolic: Double
    }
    
    func calculateMonthlyAverages() -> [MonthlyAverage] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        // Group reading items by month
        let groupedByMonth = Dictionary(grouping: viewModel.readingItems) { readingItem in
            dateFormatter.string(from: readingItem.createdDate)
        }
        
        // Calculate monthly averages
        let monthlyAverages = groupedByMonth.compactMap { (key, value) -> MonthlyAverage? in
            guard let firstItem = value.first else { return nil }
            let systolicSum = value.reduce(0.0) { $0 + $1.systolic }
            let diastolicSum = value.reduce(0.0) { $0 + $1.diastolic }
            let averageSystolic = systolicSum / Double(value.count)
            let averageDiastolic = diastolicSum / Double(value.count)
            
            return MonthlyAverage(month: key, averageSystolic: averageSystolic, averageDiastolic: averageDiastolic)
        }
        
        return monthlyAverages
    }
    
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
                    ForEach(calculateMonthlyAverages(), id: \.month) { monthlyAverage in
                        VStack(alignment: .leading) {
                            Text("MTD average readings for " + monthlyAverage.month)
                            Text("Systolic Reading: \(String(format: "%.2f", monthlyAverage.averageSystolic))")
                            Text("Diastolic Reading: \(String(format: "%.2f", monthlyAverage.averageDiastolic))")
                            Text("Average Condition: ")
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
