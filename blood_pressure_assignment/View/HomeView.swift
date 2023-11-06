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
    // Add other properties as needed
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        // Add other coding keys for additional properties
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State var users: [User] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("blood_pressure")
                    .padding(.bottom)
                
                Text("Family Member: \(viewModel.selectedUser)")
                
                Picker("Select a Family Member", selection: $viewModel.selectedUser) {
                    ForEach(users, id: \.name) { user in
                        Text(user.name)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
            }
            .toolbar {
                Button {
                    
                } label: {
                    if !viewModel.selectedUser.isEmpty {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding()
        }
        .onAppear {
            // Fetch users from Firestore when the view appears
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
                print("No documents found.")
                return
            }
            
            // Parse documents into User objects and update the users array
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
}

#Preview {
    HomeView()
}
