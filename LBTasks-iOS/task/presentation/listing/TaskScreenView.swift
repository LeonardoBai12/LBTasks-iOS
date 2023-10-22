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
    @State var isEditing = false
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
                                isEditing: $isEditing,
                                onEditAction: {
                                    taskToEdit = task
                                    
                                    if isEditing {
                                        showSheet.toggle()
                                    }
                                }
                            )
                        }.onDelete(perform: { indexSet in
                            if let indexToDelete = indexSet.first, indexToDelete < filteredTasks.count {
                                let taskToDelete = filteredTasks[indexToDelete]
                                onDelete(task: taskToDelete)
                            }
                        })
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton().simultaneousGesture(TapGesture().onEnded({
                                isEditing.toggle()
                            }))
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
                    .searchable(text: $searchFilter, placement: .navigationBarDrawer(displayMode: .always))
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
    
    @State private var isEditing: Binding<Bool>
    @State private var onEditAction: () -> Void
    
    init(
        task: TaskData,
        user: UserData,
        isEditing: Binding<Bool>,
        onEditAction: @escaping () -> Void
    ) {
        self.task = task
        self.user = user
        self.isEditing = isEditing
        self.onEditAction = onEditAction
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: task.taskType.getTaskTypeByName()?.getImageName() ?? "")
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .frame(width: 40, height: 40)
                    .background(.placeholder)
                    .cornerRadius(8)
                    .padding(.trailing, 5)
                    .padding(.vertical, 2)
                
                Text(task.title)
                
                if !(task.description ?? "").isEmpty {
                    Spacer()
                    Image(systemName: icon)
                }
            }.onTapGesture {
                if !(task.description ?? "").isEmpty && !isEditing.wrappedValue {
                    showDescription.toggle()
                    
                    withAnimation(.interactiveSpring) {
                        if !showDescription {
                            icon = "chevron.right"
                        } else {
                            icon = "chevron.down"
                        }
                    }
                }
                
                onEditAction()
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
