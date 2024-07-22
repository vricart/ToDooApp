//
//  CategoryDetailView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 10.07.2024.
//

import SwiftUI

struct CategoryDetailView: View {
    @ObservedObject var viewModel: TaskViewModel
    var category: String
    @Environment(\.presentationMode) var presentationMode
    @State private var isAddingToDo = false
    
    var itemCount: Int {
        viewModel.taskCount(for: category)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView().offset(y: -300)
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 100)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Image(TaskViewModel.imageName(for: category))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 64)
                            
                            VStack(alignment: .leading) {
                                Text("\(itemCount) \(itemCount <= 1 ? "task" : "tasks")")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.gray)
                                
                                Text(category.capitalized)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.bottom, 32)
                        
                        List {
                            ForEach(viewModel.tasks(for: category)) { task in
                                HStack {
                                    Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                        .onTapGesture {
                                            toggleCompletion(for: task)
                                        }
                                    
                                    NavigationLink(destination: EditTaskView(viewModel: viewModel, task: task)) {
                                        Text(task.title)
                                            .font(.title2)
                                            .foregroundColor(task.isCompleted ? .gray : .primary)
                                            .strikethrough(task.isCompleted, color: .gray)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                            }
                            .onDelete(perform: deleteTasks)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding(.horizontal, 40)
                }
                
                FloatingAddButton(isPresented: $isAddingToDo, isCentered: false)
            }
            .sheet(isPresented: $isAddingToDo) {
                AddTaskView(viewModel: viewModel)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    private func toggleCompletion(for task: Task) {
        if let index = viewModel.taskList.firstIndex(where: { $0.id == task.id }) {
            viewModel.taskList[index].isCompleted.toggle()
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        let tasksToDelete = offsets.map { viewModel.tasks(for: category)[$0] }
        for task in tasksToDelete {
            viewModel.deleteTask(id: task.id)
        }
    }
}

#Preview {
    CategoryDetailView(viewModel: TaskViewModel(), category: "Personal")
}
