//
//  DataView.swift
//  blood_pressure_assignment
//
//  Created by Jackie Ma on 2023-11-05.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct DataView: View {
    @StateObject var viewModel = DatabaseViewModel()
    @StateObject var dataViewModel = DataViewModel()
    @StateObject var reportViewModel = ReportViewModel()
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if notificationViewModel.showBanner {
                    NotificationView(message: "Warning: Reading in Hypertensive Crisis range. Please consult your doctor immediately.", dismissAction: {
                        notificationViewModel.showBanner.toggle()
                    })
                }
                
                Text("Add, Edit or Delete Readings\n")
                    .font(.title2)
                
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
                        ReadingItemView(viewModel: viewModel, readingItem: readingItem)
                            .swipeActions(content: {
                                Button("Delete") {
                                    viewModel.deleteReadingItem(readingItem.id!)
                                    viewModel.fetchReadingItems()
                                }
                                .tint(.red)
                            })
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .toolbar {
                Button {
                    dataViewModel.isAddingReadingItem.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(viewModel.selectedUserId.isEmpty)
            }
            .sheet(isPresented: $dataViewModel.isAddingReadingItem) {
                AddReadingItemView(viewModel: viewModel, dataViewModel: dataViewModel, reportViewModel: reportViewModel)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    DataView()
        .environmentObject(NotificationViewModel())
}
