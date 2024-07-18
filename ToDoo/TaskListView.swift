//
//  TaskListView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 15.07.2024.
//

import SwiftUI
import FirebaseAuth

struct TaskListView: View {
    @StateObject var viewModel = TaskViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @Binding var showSignUp: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, \(authManager.userName)")
                    .font(.largeTitle)
                    .padding()

                List {
                    ForEach(viewModel.categories, id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(viewModel: viewModel, category: category)) {
                            HStack {
                                Text(category)
                                Spacer()
                                Text("\(viewModel.taskCount(for: category))")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: AddTaskView(viewModel: viewModel)) {
                            Image(systemName: "plus")
                        }
                        Button(action: {
                            authManager.signOut()
                            showSignUp = false
                            dismiss()
                        }) {
                            Image(systemName: "arrow.backward.square")
                        }
                    }
                }
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                authManager.userName = user.displayName ?? "User"
            }
        }
    }
}

#Preview {
    TaskListView(showSignUp: .constant(false))
        .environmentObject(AuthManager())
}
