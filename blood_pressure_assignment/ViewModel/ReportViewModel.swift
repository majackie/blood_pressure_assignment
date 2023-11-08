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
        } else if (120...129).contains(systolic) && diastolic < 80  {
            return "Elevated"
        } else if (130...139).contains(systolic) || (80...89).contains(diastolic) {
            return "Stage 1"
        } else if (140...179).contains(systolic) || (90...119).contains(diastolic) {
            return "Stage 2"
        } else if systolic > 180 || diastolic > 120 {
            return "Hypertensive"
        } else {
            return "NA"
        }
    }
}
