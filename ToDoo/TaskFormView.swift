import SwiftUI

struct TaskFormView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var category: String
    @Binding var categories: [String]
    @Binding var newCategory: String
    @Binding var doneBy: Date?
    @Binding var includeNewCategory: Bool
    @Binding var includeDoneBy: Bool
    let isCompletedBinding: Binding<Bool>?

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $description)
            }
            Section(header: Text("Category")) {
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Toggle("Add New Category", isOn: $includeNewCategory)
                if includeNewCategory {
                    TextField("New Category", text: $newCategory)
                    Button("Add Category") {
                        if !categories.contains(newCategory) && !newCategory.isEmpty {
                            categories.append(newCategory)
                            category = newCategory
                            newCategory = ""
                        }
                    }
                    .disabled(newCategory.isEmpty)
                }
            }
            Section {
                Toggle("Include Done By Date", isOn: $includeDoneBy)
                if includeDoneBy {
                    DatePicker("Done By", selection: Binding($doneBy, replacingNilWith: Date()), displayedComponents: .date)
                }
            }
            if let isCompletedBinding = isCompletedBinding {
                Section {
                    Toggle("Completed", isOn: isCompletedBinding)
                }
            }
        }
    }
}

extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith nilValue: Value) {
        self.init(
            get: { source.wrappedValue ?? nilValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

#Preview {
    TaskFormView(
        title: .constant("Sample Task"),
        description: .constant("This is a sample description."),
        category: .constant("Personal"),
        categories: .constant(["Personal", "Work", "Shopping", "Today", "Planned"]),
        newCategory: .constant(""),
        doneBy: .constant(Date()),
        includeNewCategory: .constant(false),
        includeDoneBy: .constant(true),
        isCompletedBinding: .constant(false)
    )
}
