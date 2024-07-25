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
        _category = State(initialValue: task.category)
        _doneBy = State(initialValue: task.doneBy)
        _includeNewCategory = State(initialValue: !task.category.isEmpty && !viewModel.categories.contains(task.category))
        _includeDoneBy = State(initialValue: task.doneBy != nil)
    }

    var body: some View {
        NavigationStack {
            VStack {
                TaskFormView(
                    title: $title,
                    description: $description,
                    category: $category,
                    categories: $viewModel.categories,
                    newCategory: $newCategory,
                    doneBy: $doneBy,
                    includeNewCategory: $includeNewCategory,
                    includeDoneBy: $includeDoneBy
                )
                
                Spacer(minLength: 100)
                
                CustomButton(title: "Save", action: updateTask, isDisabled: title.isEmpty)
                    .padding()
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: title) {
            print("Title changed to: \(title)") // Debug print
        }
        .onChange(of: description) {
            print("Description changed to: \(description)") // Debug print
        }
    }

    private func updateTask() {
        let finalCategory = determineFinalCategory()
        viewModel.updateTask(id: task.id, title: title, description: description, isCompleted: task.isCompleted, category: finalCategory, doneBy: includeDoneBy ? doneBy : nil)
        dismiss()
    }

    private func determineFinalCategory() -> String {
        if includeNewCategory && !newCategory.isEmpty {
            if !viewModel.categories.contains(newCategory) {
                viewModel.addCategory(name: newCategory)
            }
            return newCategory
        } else {
            return category
        }
    }
}

#Preview {
    EditTaskView(
        viewModel: TaskViewModel(),
        task: Task(title: "Sample Task", description: "Sample Description", category: "Personal", doneBy: Date())
    )
}
