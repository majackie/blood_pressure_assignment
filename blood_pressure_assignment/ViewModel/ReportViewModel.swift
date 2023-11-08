//
//  ReportViewModel.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import SwiftUI

class ReportViewModel : ObservableObject {
    func calculateMonthlyAverages(readingItems: [ReadingItem]) -> [MonthlyAverage] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        let groupedByMonth = Dictionary(grouping: readingItems) { readingItem in
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
        } else if systolic < 130 && diastolic < 80 {
            return "Elevated"
        } else if systolic < 140 || diastolic < 90 {
            return "Stage 1"
        } else if systolic < 180 && diastolic < 120 {
            return "Stage 2"
        } else {
            return "Hypertensive"
        }
    }
}
