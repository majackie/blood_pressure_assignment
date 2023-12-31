//
//  DatabaseViewModel.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import FirebaseFirestore

class DatabaseViewModel : ObservableObject {
    @Published var selectedUserId = ""
    @Published var users: [User] = []
    @Published var readingItems: [ReadingItem] = []
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        return dateFormatter.string(from: date)
    }
    
    func isValidNumber(_ value: String) -> Bool {
        return Double(value) != nil
    }
    
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No users found.")
                return
            }
            
            self.users = documents.compactMap { document in
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    func fetchReadingItems() {
        guard !selectedUserId.isEmpty else {
            print("No selected user to fetch reading items for.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(selectedUserId)
        
        userRef.collection("readingItems").order(by: "createdDate", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching readingItems: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No readingItems found for the selected user.")
                return
            }
            
            self.readingItems = documents.compactMap { document in
                do {
                    return try document.data(as: ReadingItem.self)
                } catch {
                    print("Error decoding reading item: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    func addReadingItem(systolic: Double, diastolic: Double, createdDate: Date) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(selectedUserId)
        
        let formattedSystolic = Double(String(format: "%.2f", systolic))
        let formattedDiastolic = Double(String(format: "%.2f", diastolic))
        
        let newReadingItem = ReadingItem(
            systolic: formattedSystolic!,
            diastolic: formattedDiastolic!,
            createdDate: createdDate
        )
        
        do {
            _ = try userRef.collection("readingItems").addDocument(from: newReadingItem)
        } catch {
            print("Error adding readingItem: \(error.localizedDescription)")
        }
    }

    func editReadingItem(_ readingItem: ReadingItem, systolic: Double, diastolic: Double) {
        let db = Firestore.firestore()

        if let readingItemId = readingItem.id {
            let userRef = db.collection("users").document(selectedUserId)
            
            let formattedSystolic = Double(String(format: "%.2f", systolic))
            let formattedDiastolic = Double(String(format: "%.2f", diastolic))

            let updatedReadingItem = ReadingItem(
                id: readingItemId,
                systolic: formattedSystolic!,
                diastolic: formattedDiastolic!,
                createdDate: readingItem.createdDate
            )
            
            do {
                try userRef.collection("readingItems").document(readingItemId).setData(from: updatedReadingItem, merge: true)
            } catch {
                print("Error editing readingItem: \(error.localizedDescription)")
            }
        } else {
            print("Error: readingItem.id is nil")
        }
    }

    func deleteReadingItem(_ readingItemID: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(selectedUserId)
        
        userRef.collection("readingItems").document(readingItemID).delete { error in
            if let error = error {
                print("Error deleting reading item: \(error.localizedDescription)")
            } else {
                print("Reading item deleted successfully.")
            }
        }
    }
}
