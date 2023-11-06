//
//  HomeViewModel.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import FirebaseFirestore

class HomeViewModel : ObservableObject {
    @Published var selectedMember = ""
    @Published var showingNewItemView = false
    private let _userId: String
    
    init(userId: String) {
        _userId = userId
    }
    
    func delete(id: String) {
        var db = Firestore.firestore()
        
        db.collection("users")
            .document(_userId)
            .collection("todos")
            .document(id)
            .delete()
    }
}
