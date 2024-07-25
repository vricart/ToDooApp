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
    @State private var category: String
    @State private var newCategory = ""
    @State private var doneBy: Date? = nil
    @State private var includeNewCategory = false
    @State private var includeDoneBy = false

    init(viewModel: TaskViewModel, defaultCategory: String? = nil) {
        self.viewModel = viewModel
        _category = State(initialValue: defaultCategory ?? (viewModel.categories.first { $0 != "Today" && $0 != "Planned" } ?? "Personal"))
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
                
                Spacer()
                
                CustomButton(title: "Add Task", action: addTask, isDisabled: title.isEmpty)
                    .padding()
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: title) {
            print("Title changed to: \(title)") // Debug print
        }
        .onChange(of: description) {
            print("Description changed to: \(description)") // Debug print
        }
    }

    private func addTask() {
        let finalCategory = determineFinalCategory()
        viewModel.addTask(title: title, description: description, category: finalCategory, doneBy: includeDoneBy ? doneBy : nil)
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
    AddTaskView(viewModel: TaskViewModel(), defaultCategory: "Personal")
}
