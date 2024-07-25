import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class TaskViewModel: ObservableObject {
    @Published var taskList: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    @Published var categories: [String] = ["Today", "Planned", "Personal", "Work", "Shopping"] {
        didSet {
            saveCategories()
        }
    }

    private var tasksKey: String {
        guard let userID = Auth.auth().currentUser?.uid else {
            return "tasks"
        }
        return "tasks_\(userID)"
    }

    private var categoriesKey: String {
        guard let userID = Auth.auth().currentUser?.uid else {
            return "categories"
        }
        return "categories_\(userID)"
    }

    init() {
        loadTasks()
        loadCategories()
    }

    func addTask(title: String, description: String, category: String, doneBy: Date?) {
        let newTask = Task(title: title, description: description, category: category, doneBy: doneBy)
        taskList.append(newTask)
        if !categories.contains(category) && category != "Today" && category != "Planned" {
            addCategory(name: category)
        }
    }

    func updateTask(id: UUID, title: String, description: String, isCompleted: Bool, category: String, doneBy: Date?) {
        if let index = taskList.firstIndex(where: { $0.id == id }) {
            taskList[index].title = title
            taskList[index].description = description
            taskList[index].isCompleted = isCompleted
            taskList[index].category = category
            taskList[index].doneBy = doneBy
            if !categories.contains(category) && category != "Today" && category != "Planned" {
                addCategory(name: category)
            }
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

    func deleteCategory(name: String) {
        guard name != "Today", name != "Planned" else { return }
        categories.removeAll { $0 == name }
        taskList.removeAll { $0.category == name }
    }

    func taskCount(for category: String) -> Int {
        switch category {
        case "Today":
            return taskList.filter { $0.doneBy?.isToday == true || ($0.doneBy == nil && $0.category != "Planned") }.count
        case "Planned":
            return taskList.filter { $0.doneBy != nil }.count
        default:
            return taskList.filter { $0.category == category }.count
        }
    }

    func tasks(for category: String) -> [Task] {
        switch category {
        case "Today":
            return taskList.filter { $0.doneBy?.isToday == true || ($0.doneBy == nil && $0.category != "Planned") }
        case "Planned":
            return taskList.filter { $0.doneBy != nil }
        default:
            return taskList.filter { $0.category == category }
        }
    }
    
    func tasksGroupedByDueDate(for category: String) -> [(String, [Task])] {
        guard category == "Planned" else {
            return []
        }
        
        let groupedTasks = Dictionary(grouping: tasks(for: category)) { task in
            task.doneBy?.formatted(.dateTime.year().month().day()) ?? "No Date"
        }
        
        return groupedTasks.sorted { $0.key < $1.key }
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

    static func imageName(for category: String) -> String {
        switch category {
        case "Personal":
            return "to-do-list"
        case "Work":
            return "suitcase"
        case "Shopping":
            return "shopping-cart"
        case "Today":
            return "sun"
        case "Planned":
            return "calendar"
        default:
            return "to-do-list"
        }
    }
}

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
