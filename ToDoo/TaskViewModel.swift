import Foundation
import SwiftUI

@MainActor
class TaskViewModel: ObservableObject {
    @Published var taskList: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    @Published var categories: [String] = ["Personal", "Work", "Shopping", "Today", "Planned"] {
        didSet {
            saveCategories()
        }
    }

    private let tasksKey = "tasks"
    private let categoriesKey = "categories"

    init() {
        loadTasks()
        loadCategories()
    }

    func addTask(title: String, description: String, category: String, doneBy: Date?) {
        let newTask = Task(title: title, description: description, category: category, doneBy: doneBy)
        taskList.append(newTask)
    }

    func updateTask(id: UUID, title: String, description: String, isCompleted: Bool, category: String, doneBy: Date?) {
        if let index = taskList.firstIndex(where: { $0.id == id }) {
            taskList[index].title = title
            taskList[index].description = description
            taskList[index].isCompleted = isCompleted
            taskList[index].category = category
            taskList[index].doneBy = doneBy
        }
    }

    func deleteTask(id: UUID) {
        taskList.removeAll { $0.id == id }
    }

    func addCategory(name: String) {
        if !categories.contains(name) {
            categories.append(name)
        }
    }

    func taskCount(for category: String) -> Int {
        switch category {
        case "Today":
            return taskList.filter { $0.doneBy?.isToday == true || ($0.doneBy == nil && $0.category != "Planned") }.count
        case "Planned":
            return taskList.filter { $0.doneBy != nil && !$0.doneBy!.isToday }.count
        default:
            return taskList.filter { $0.category == category }.count
        }
    }

    func tasks(for category: String) -> [Task] {
        switch category {
        case "Today":
            return taskList.filter { $0.doneBy?.isToday == true || ($0.doneBy == nil && $0.category != "Planned") }
        case "Planned":
            return taskList.filter { $0.doneBy != nil && !$0.doneBy!.isToday }
        default:
            return taskList.filter { $0.category == category }
        }
    }

    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(taskList) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }

    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            taskList = decodedTasks
        }
    }

    private func saveCategories() {
        UserDefaults.standard.set(categories, forKey: categoriesKey)
    }

    private func loadCategories() {
        if let savedCategories = UserDefaults.standard.stringArray(forKey: categoriesKey) {
            categories = savedCategories
        }
    }
}

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}

