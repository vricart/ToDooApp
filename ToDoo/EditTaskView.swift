//
//  EditTaskView.swift
//  ToDoo
//
//  Created by Marc Vicky Ricart on 10.07.2024.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    var task: Task
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool
    @State private var category: String
    @State private var newCategory = ""
    @State private var doneBy: Date?
    @State private var includeNewCategory = false
    @State private var includeDoneBy = false
    
    init(viewModel: TaskViewModel, task: Task) {
        self.viewModel = viewModel
        self.task = task
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _isCompleted = State(initialValue: task.isCompleted)
        _category = State(initialValue: task.category)
        _doneBy = State(initialValue: task.doneBy)
        _includeNewCategory = State(initialValue: !task.category.isEmpty && !["Personal", "Work", "Shopping", "Today", "Planned"].contains(task.category))
        _includeDoneBy = State(initialValue: task.doneBy != nil)
    }
    
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
            isCompletedBinding: $isCompleted
        )
        .navigationTitle("Edit Task")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    let taskCategory = includeNewCategory ? category : "Personal"
                    let taskDoneBy = includeDoneBy ? doneBy : nil
                    let taskIsPlanned = taskDoneBy != nil && taskDoneBy! > Date()
                    let finalCategory = taskIsPlanned ? "Planned" : taskCategory
                    viewModel.updateTask(id: task.id, title: title, description: description, isCompleted: isCompleted, category: finalCategory, doneBy: taskDoneBy)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EditTaskView(
        viewModel: TaskViewModel(),
        task: Task(title: "Sample Task", description: "Sample Description", category: "Personal", doneBy: Date())
    )
}
