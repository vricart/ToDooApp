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

    var body: some View {
        List {
            ForEach(viewModel.tasks(for: category)) { task in
                NavigationLink(destination: EditTaskView(viewModel: viewModel, task: task)) {
                    HStack {
                        Text(task.title)
                        Spacer()
                        if task.isCompleted {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .onDelete(perform: { indexSet in
                indexSet.map { viewModel.tasks(for: category)[$0] }.forEach { viewModel.deleteTask(id: $0.id) }
            })
        }
        .navigationTitle(category)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddTaskView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    CategoryDetailView(viewModel: TaskViewModel(), category: "Personal")
}
