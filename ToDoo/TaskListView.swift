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
    @State private var isAddingToDo = false
    @State private var defaultCategory: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView().edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hello, \(authManager.userName)")
                                .font(.title).bold()
                                .padding(.bottom, 2)
                            
                            Text("Today you have \(viewModel.taskCount(for: "Today")) \(viewModel.taskCount(for: "Today") <= 1 ? "task" : "tasks")")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Image("profile-img")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 32)

                    ScrollView {
                        VStack(spacing: 16) {
                            Spacer()
                            ForEach(viewModel.categories, id: \.self) { category in
                                NavigationLink(destination: CategoryDetailView(viewModel: viewModel, category: category)) {
                                    CategoryCardView(category: category, taskCount: viewModel.taskCount(for: category))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 8)
                
                FloatingAddButton(isPresented: $isAddingToDo, isCentered: true)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            authManager.signOut()
                            showSignUp = false
                            dismiss()
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
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
        .sheet(isPresented: $isAddingToDo) {
            AddTaskView(viewModel: viewModel, defaultCategory: defaultCategory)
        }
    }
}

#Preview {
    TaskListView(showSignUp: .constant(false))
        .environmentObject(AuthManager())
}
