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
    
    @State var isAddingReadingItem = false
    @State var systolic: Double?
    @State var diastolic: Double?
    
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
                        VStack {
                            HStack {
                                Text("Systolic: \(String(format: "%.2f", readingItem.systolic)) ")
                                Spacer()
                                Text("Diastolic: \(String(format: "%.2f", readingItem.diastolic))")
                            }
                            .listRowSeparator(.hidden)
                            HStack {
                                Text("Date: \(viewModel.formatDate(readingItem.createdDate))")
                                Spacer()
                            }
                        }
                        .swipeActions(content: {
                            Button("Delete") {

                            }
                            .tint(.red)
                        })
                    }
                }
                
                Spacer()
            }
            .toolbar {
                Button {
                    isAddingReadingItem.toggle()
                } label: {
                    if !viewModel.selectedUserId.isEmpty {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding()
            .sheet(isPresented: $isAddingReadingItem) {
                VStack {
                    HStack {
                        Text("Systolic: ")
                        TextField("", value: $systolic, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Diastolic: ")
                        TextField("", value: $diastolic, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    Button("Save") {
                        viewModel.addReadingItem(systolic: systolic!, diastolic: diastolic!, createdDate: Date.now)
                        isAddingReadingItem.toggle()
                    }
                }
                .padding()
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
