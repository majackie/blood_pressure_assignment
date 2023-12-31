//
//  ReadingItem.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import FirebaseFirestoreSwift

struct ReadingItem: Identifiable, Codable {
    @DocumentID var id: String?
    var systolic: Double
    var diastolic: Double
    var createdDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case systolic
        case diastolic
        case createdDate
    }
}
