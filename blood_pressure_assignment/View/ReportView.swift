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
        let averageCondition: String
    }
    
    func calculateMonthlyAverages() -> [MonthlyAverage] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        let groupedByMonth = Dictionary(grouping: viewModel.readingItems) { readingItem in
            dateFormatter.string(from: readingItem.createdDate)
        }
        
        let monthlyAverages = groupedByMonth.compactMap { (key, value) -> MonthlyAverage? in
            let systolicSum = value.reduce(0.0) { $0 + $1.systolic }
            let diastolicSum = value.reduce(0.0) { $0 + $1.diastolic }
            let averageSystolic = systolicSum / Double(value.count)
            let averageDiastolic = diastolicSum / Double(value.count)
            let averageCondition = calculateAverageCondition(systolic: averageSystolic, diastolic: averageDiastolic)
            
            return MonthlyAverage(month: key, averageSystolic: averageSystolic, averageDiastolic: averageDiastolic, averageCondition: averageCondition)
        }
        
        return monthlyAverages
    }
    
    func calculateAverageCondition(systolic: Double, diastolic: Double) -> String {
        if systolic < 120 && diastolic < 80 {
            return "Normal"
        } else if (120...129).contains(systolic) && diastolic < 80  {
            return "Elevated"
        } else if (130...139).contains(systolic) || (80...89).contains(diastolic) {
            return "High Blood Pressure (Stage 1)"
        } else if (140...179).contains(systolic) || (90...119).contains(diastolic) {
            return "High Blood Pressure (Stage 2)"
        } else if systolic > 180 || diastolic > 120 {
            return "Hypertensive Crisis"
        } else {
            return "NA"
        }
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
