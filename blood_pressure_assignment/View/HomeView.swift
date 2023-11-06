//
//  HomeView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI
import FirebaseFirestoreSwift

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @FirestoreQuery var items: [ReadingData]
    
    init(userId: String) {
//        self._items = FirestoreQuery(collectionPath: "users/\(userId)/readingData")
        self._items = FirestoreQuery(collectionPath: "users/N8NzAxhRXJFvdyDoNqXH/readingData")
        
        self._viewModel = StateObject(wrappedValue: HomeViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("blood_pressure")
                    .padding(.bottom)
                
                // Text("Family Member: \(selectedMember)")
                
                Picker("Select a Family Member", selection: $viewModel.selectedMember) {
                    ForEach(familyMembers, id: \.name) { member in
                        Text(member.name)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
            }
            .toolbar {
                Button {
                    viewModel.showingNewItemView = true
                } label: {
                    if !viewModel.selectedMember.isEmpty {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(userId: "N8NzAxhRXJFvdyDoNqXH")
}
