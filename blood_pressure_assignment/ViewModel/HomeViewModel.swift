//
//  HomeViewModel.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import Foundation
import FirebaseFirestore

class HomeViewModel : ObservableObject {
    @Published var selectedUserId = ""
    @Published var users: [User] = []
    @Published var readingItems: [ReadingItem] = []
    @Published var isAddingReadingItem = false
    
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
        
        userRef.collection("readingItems").getDocuments { querySnapshot, error in
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
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func addReadingItem(systolic: Double, diastolic: Double, createdDate: Date) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(selectedUserId)
        
        let newReadingItem = ReadingItem(diastolic: diastolic, systolic: systolic, createdDate: createdDate)
        
        do {
            _ = try userRef.collection("readingItems").addDocument(from: newReadingItem)
        } catch {
            print("Error adding readingItem: \(error.localizedDescription)")
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
    
    func editReadingItem(_ readingItem: ReadingItem, systolic: Double, diastolic: Double) {
        let db = Firestore.firestore()
        
        if let readingItemId = readingItem.id {
            let userRef = db.collection("users").document(selectedUserId)
            
            let updatedReadingItem = ReadingItem(
                id: readingItemId,
                diastolic: diastolic,
                systolic: systolic,
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

}
