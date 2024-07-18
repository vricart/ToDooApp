//
//  AddTaskView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 10.07.2024.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var category: String = "Personal"
    @State private var newCategory = ""
    @State private var doneBy: Date? = nil
    @State private var includeNewCategory = false
    @State private var includeDoneBy = false

    var body: some View {
        TaskFormView(
            title: $title,
            description: $description,
            category: $category,
            categories: $viewModel.categories,
            newCategory: $newCategory,
            doneBy: $doneBy,
            includeNewCategory: $includeNewCategory,
            includeDoneBy: $includeDoneBy,
            isCompletedBinding: nil
        )
        .navigationTitle("Add Task")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let taskCategory = includeNewCategory ? category : "Personal"
                    let taskDoneBy = includeDoneBy ? doneBy : nil
                    let taskIsPlanned = taskDoneBy != nil && taskDoneBy! > Date()
                    let finalCategory = taskIsPlanned ? "Planned" : taskCategory
                    viewModel.addTask(title: title, description: description, category: finalCategory, doneBy: taskDoneBy)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddTaskView(viewModel: TaskViewModel())
}
