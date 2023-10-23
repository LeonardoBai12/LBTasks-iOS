//
//  TaskDetailsScreenView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import SwiftUI

struct TaskDetailsScreenView: View {
    private var task: TaskData?
    
    @ObservedObject var viewModel: TaskDetailsViewModel
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedDate: String
    @State private var editedTime: String
    
    @State private var hasDeadlineDate: Bool
    @State private var hasDeadlineTime: Bool
    
    @State private var selectedTaskType: TaskType? = nil
    
    @State private var showAlert = false
    @State private var errorMessage = "Unknown error"
    
    private var isEdit = false
    private var navigationTitle = "New task"
    private let onDone: () -> Void
    
    private var user: UserData
    private var taskData: TaskData?

    init(
        viewModel: TaskDetailsViewModel,
        task: TaskData?,
        user: UserData,
        onDone: @escaping () -> Void
    ) {
        editedTitle = task?.title ?? ""
        editedDescription = task?.description ?? ""
        
        editedDate = !(task?.deadlineDate ?? "").isEmpty ? task!.deadlineDate!.replacingOccurrences(of: "-", with: "/") : Date().asDateString()
        editedTime = !(task?.deadlineTime ?? "").isEmpty ? task!.deadlineTime! : Date().asTimeString()
        
        isEdit = task != nil
        
        if isEdit {
            navigationTitle = task!.title
        }
        
        self.onDone = onDone
        self.viewModel = viewModel
        self.user = user
        self.taskData = task
        self.hasDeadlineDate = !(task?.deadlineDate ?? "").isEmpty
        self.hasDeadlineTime = !(task?.deadlineTime ?? "").isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if !isEdit {
                        VStack {
                            Text("Select a task type")
                                .padding(.bottom)
                            
                            HStack {
                                Spacer()
                                TaskTypeImage(taskType: .business, selectedTaskType: $selectedTaskType)
                                Spacer()
                                TaskTypeImage(taskType: .hobbies, selectedTaskType: $selectedTaskType)
                                Spacer()
                                TaskTypeImage(taskType: .home, selectedTaskType: $selectedTaskType)
                                Spacer()
                            }.padding(.bottom, 20)
                            
                            HStack {
                                Spacer()
                                TaskTypeImage(taskType: .shopping, selectedTaskType: $selectedTaskType)
                                Spacer()
                                TaskTypeImage(taskType: .study, selectedTaskType: $selectedTaskType)
                                Spacer()
                                TaskTypeImage(taskType: .travel, selectedTaskType: $selectedTaskType)
                                Spacer()
                            }
                        }
                    }
                }
                
                Section {
                    TextField("Title", text: $editedTitle)
                }
                Section {
                    TextField("Description", text: $editedDescription)
                }
                Section {
                    HStack {
                        Text("Deadline Date")
                        Toggle(isOn: $hasDeadlineDate, label: { EmptyView() })
                    }
                    if hasDeadlineDate {
                        DatePicker(
                            "Select a date",
                            selection: Binding(
                                get: {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    if let date = dateFormatter.date(from: editedDate) {
                                        return date
                                    } else {
                                        return Date()
                                    }
                                },
                                set: { newDate in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    editedDate = dateFormatter.string(from: newDate)
                                }
                            ),
                            in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }

                Section {
                    HStack {
                        Text("Deadline Time")
                        Toggle(isOn: $hasDeadlineTime, label: { EmptyView() })
                    }
                    
                    if hasDeadlineTime {
                        DatePicker(
                            "Select a time",
                            selection: Binding(
                                get: {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "hh:mm"
                                    if let time = dateFormatter.date(from: editedTime) {
                                        return time
                                    } else {
                                        return Date()
                                    }
                                },
                                set: { newTime in
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "hh:mm"
                                    editedTime = dateFormatter.string(from: newTime)
                                }
                            ),
                            displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
            }.navigationBarTitle(navigationTitle)
                .toolbar {
                    ToolbarItem {
                        Button {
                            if isEdit {
                                viewModel.onRequestUpdate(
                                    userData: user,
                                    task: taskData!,
                                    title: editedTitle,
                                    description: editedDescription,
                                    date: hasDeadlineDate ? editedDate : "",
                                    time: hasDeadlineTime ? editedTime : ""
                                )
                            } else {
                                viewModel.onRequestInsert(
                                    userData: user,
                                    title: editedTitle,
                                    description: editedDescription,
                                    taskType: selectedTaskType?.getName() ?? "",
                                    date: hasDeadlineDate ? editedDate : "",
                                    time: hasDeadlineTime ? editedTime : ""
                                )
                            }
                            
                            if viewModel.state.isTaskSaveSuccesful {
                                onDone()
                            }
                        } label: {
                            Text("Done")
                        }
                    }
                }.alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Something went wrong"),
                        message: Text(errorMessage)
                    )
                }
                .onReceive(viewModel.$state) { state in
                    if let taskError = state.errorMessage {
                        if !taskError.isEmpty {
                            errorMessage = taskError
                            showAlert = true
                        }
                    }
                }
                .onAppear {
                    viewModel.state.errorMessage = ""
                    viewModel.state.isTaskSaveSuccesful = false
                }
        }
    }
}

struct TaskTypeImage: View {
    let taskType: TaskType
    var selectedTaskType: Binding<TaskType?>
    
    var body: some View {
        VStack {
            ZStack {
                if taskType == selectedTaskType.wrappedValue {
                    RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                        .stroke(Color.yellow, lineWidth: 4)
                        .fill(.tint)
                        .frame(width: 50, height: 50)
                } else {
                    RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                        .fill(.tint)
                        .frame(width: 50, height: 50)
                }
                
                Image(systemName: taskType.getImageName())
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .scaledToFit()
            }
            
            Text(taskType.getName().capitalized)
                .font(.callout)
        }.onTapGesture {
            selectedTaskType.wrappedValue = taskType
        }
    }
}
