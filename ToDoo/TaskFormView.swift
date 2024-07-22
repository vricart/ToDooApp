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

    var body: some View {
        ZStack {
            CustomBackgroundView(isReversed: true)
                .offset(y: 325).edgesIgnoringSafeArea(.all)
            
            Form {
                
                Section("Title") {
                    TextField("Title", text: $title)
                        .underlineTextField()
                }
                
                Section("Description") {
                    TextField("Description", text: $description)
                        .underlineTextField()
                }
                
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    
                    Toggle("Add New Category", isOn: $includeNewCategory)
                    if includeNewCategory {
                        TextField("New Category", text: $newCategory)
                            .textFieldStyle(DefaultTextFieldStyle())
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
                
                Section("Date") {
                    Toggle("Done By?", isOn: $includeDoneBy)
                    if includeDoneBy {
                        DatePicker("Done By", selection: Binding($doneBy, replacingNilWith: Date()), displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
            }
            .scrollContentBackground(.hidden)
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

extension View {
    func underlineTextField() -> some View {
        self
            .overlay(
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 0.05)
                        .foregroundColor(Color(.systemGray2))
                        .padding(.top, 35)
                }
                    .padding(.horizontal, -20)
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
        includeDoneBy: .constant(false)
    )
}
