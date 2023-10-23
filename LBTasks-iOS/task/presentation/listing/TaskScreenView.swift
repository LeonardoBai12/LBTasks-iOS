//
//  TaskScreenView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import SwiftUI

struct TaskScreenView: View {
    @ObservedObject var viewModel: TaskViewModel
    @ObservedObject var taskDetailsViewModel: TaskDetailsViewModel
    @State private var searchFilter = ""
    
    private let logout: () -> Void
    
    @State var showSheet = false
    @State private var taskToEdit: TaskData? = nil
    
    var filteredTasks: [TaskData] {
        if searchFilter.isEmpty {
            return viewModel.state.tasks
        } else {
            return viewModel.state.tasks.filter { task in
                let titleMatches = task.title.lowercased().contains(searchFilter.lowercased())
                let descriptionMatches = task.description?.lowercased().contains(searchFilter.lowercased()) ?? false
                return titleMatches || descriptionMatches
            }
        }
    }
    
    init(
        viewModel: TaskViewModel,
        taskDetailsViewModel: TaskDetailsViewModel,
        userData: UserData?,
        logout: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.taskDetailsViewModel = taskDetailsViewModel
        
        viewModel.userData = userData
        self.logout = logout
        
        if userData != nil {
            viewModel.getTasks(userData: userData!)
        }
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    List {
                        ForEach(filteredTasks) { task in                            
                            TaskRowView(
                                task: task,
                                user:  viewModel.userData!,
                                onEditAction: {
                                    taskDetailsViewModel.state.errorMessage = ""
                                    taskDetailsViewModel.state.isTaskSaveSuccesful = false
                                    taskToEdit = task
                                    showSheet.toggle()
                                }
                            )
                        }.onDelete(
                            perform: { indexSet in
                                if let indexToDelete = indexSet.first, indexToDelete < filteredTasks.count {
                                    let taskToDelete = filteredTasks[indexToDelete]
                                    onDelete(task: taskToDelete)
                                }
                            }
                        )
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                        ToolbarItem {
                            Button {
                                taskToEdit = nil
                                showSheet.toggle()
                            } label: {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(
                        isPresented: $showSheet,
                        content: {
                            TaskDetailsScreenView(
                                viewModel: taskDetailsViewModel,
                                task: taskToEdit,
                                user: viewModel.userData!,
                                onDone: {
                                    showSheet.toggle()
                                    viewModel.getTasks(userData: viewModel.userData!)
                                }
                            )
                        }
                    )
                    .searchable(text: $searchFilter)
                }
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("Tasks")
            }
            
            UserDetailsScreen(user: viewModel.userData ?? UserData(), logout: logout)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private func onDelete(task: TaskData) {
        viewModel.onRequestDelete(task: task)
    }
}

struct TaskRowView: View {
    private let task: TaskData
    private let user: UserData
    
    @State private var showDescription = false
    @State private var icon = "chevron.right"
    
    @State private var onEditAction: () -> Void
    
    init(
        task: TaskData,
        user: UserData,
        onEditAction: @escaping () -> Void
    ) {
        self.task = task
        self.user = user
        self.onEditAction = onEditAction
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    onEditAction()
                } label: {
                    HStack {
                        Image(systemName: task.taskType.getTaskTypeByName()?.getImageName() ?? "")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(.tint)
                            .cornerRadius(8)
                            .padding(.vertical, 2)
                        
                        VStack {
                            Text(task.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .tint(.primary)
                                .bold()
                            
                            HStack {
                                if !(task.deadlineDate ?? "").isEmpty {
                                    Text(task.deadlineDate!.replacingOccurrences(of: "-", with: "/"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .tint(.primary)
                                }
                                if !(task.deadlineTime ?? "").isEmpty {
                                    Text(task.deadlineTime!)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .tint(.primary)
                                }
                            }
                        }.padding(.leading, 5)
                    }
                }
                
                if !(task.description ?? "").isEmpty {
                    Image(systemName: icon)
                        .frame(width: 20)
                        .onTapGesture {
                            if !(task.description ?? "").isEmpty {
                                showDescription.toggle()
                                
                                withAnimation(.interactiveSpring) {
                                    if !showDescription {
                                        icon = "chevron.right"
                                    } else {
                                        icon = "chevron.down"
                                    }
                                }
                            }
                        }
                }
            }
            
            if showDescription {
                Text(task.description ?? "")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
        }
    }
}
