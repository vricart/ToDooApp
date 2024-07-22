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
                
                CustomButton(title:"Add Task") {
                    addTask()
                }
                .padding()
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
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
        } else if includeDoneBy && doneBy != nil && doneBy! > Date() {
            return "Planned"
        } else {
            return category
        }
    }
}

#Preview {
    AddTaskView(viewModel: TaskViewModel())
}
