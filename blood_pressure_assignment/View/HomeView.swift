//
//  HomeView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
}

struct ReadingItem: Identifiable, Codable {
    @DocumentID var id: String?
    var diastolic: Double
    var systolic: Double
    var createdDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case diastolic
        case systolic
        case createdDate
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State var users: [User] = []
    @State var readingItems: [ReadingItem] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("blood_pressure")
                    .padding(.bottom)
                
                Text("User ID: \(viewModel.selectedUserId)")
                
                Picker("Select a Family Member", selection: $viewModel.selectedUserId) {
                    ForEach(users, id: \.id!) { user in
                        Text(user.name)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectedUserId) { newValue, _ in
                    fetchReadingItems()
                }
                
                List(readingItems) { readingItem in
                    VStack(alignment: .leading) {
                        Text("Systolic: \(String(format: "%.2f", readingItem.systolic)) ")
                        Text("Diastolic: \(String(format: "%.2f", readingItem.diastolic))")
                        Text("Date: \(formatDate(readingItem.createdDate))")
                    }
                }
                
                Spacer()
            }
            .toolbar {
                Button {
                    
                } label: {
                    if !viewModel.selectedUserId.isEmpty {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding()
        }
        .onAppear {
            fetchUsers()
        }
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
            
            users = documents.compactMap { document in
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
        guard !viewModel.selectedUserId.isEmpty else {
            print("No selected user to fetch reading items for.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(viewModel.selectedUserId)
        
        userRef.collection("readingItems").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching readingItems: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No readingItems found for the selected user.")
                return
            }
            
            readingItems = documents.compactMap { document in
                do {
                    return try document.data(as: ReadingItem.self)
                } catch {
                    print("Error decoding reading item: \(error.localizedDescription)")
                    return nil
                }
            }
            print(readingItems)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    HomeView()
}
