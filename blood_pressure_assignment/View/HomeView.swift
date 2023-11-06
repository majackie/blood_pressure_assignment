//
//  HomeView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("blood_pressure")
                    .padding(.bottom)
                
                Text("User ID: \(viewModel.selectedUserId)")
                
                Picker("Select a Family Member", selection: $viewModel.selectedUserId) {
                    ForEach(viewModel.users, id: \.id!) { user in
                        Text(user.name)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectedUserId) { newValue, _ in
                    viewModel.fetchReadingItems()
                }
                
                List {
                    ForEach(viewModel.readingItems) { readingItem in
                        ReadingItemView(readingItem: readingItem)
                            .swipeActions(content: {
                                Button("Delete") {
                                    viewModel.deleteReadingItem(readingItem.id!)
                                    viewModel.fetchReadingItems()
                                }
                                .tint(.red)
                            })
                    }
                }
                
                Spacer()
            }
            .toolbar {
                Button {
                    viewModel.isAddingReadingItem.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(viewModel.selectedUserId.isEmpty)
            }
            .padding()
            .sheet(isPresented: $viewModel.isAddingReadingItem) {
                AddReadingItemView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    HomeView()
}
