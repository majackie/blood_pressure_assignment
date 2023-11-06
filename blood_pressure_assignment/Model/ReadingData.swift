//
//  ReadingData.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation

struct ReadingData: Codable, Identifiable {
    let id: String
    let systolic: Float
    let diastolic: Float
    let createdDate: Date
}
