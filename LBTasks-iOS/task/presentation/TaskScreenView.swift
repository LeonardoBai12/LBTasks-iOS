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
    @State private var taskToEdit: TaskData? = nil
    
    private let logout: () -> Void
    
    @State var showSheet = false
    
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
        NavigationStack {
            VStack {
                List(filteredTasks, id: \.uuid) { task in
                    TaskRowView(task: task, user:  viewModel.userData!)
                    
                    
                   // taskToEdit = task
               //     showSheet.toggle()
                    
                }
                .toolbar {
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
            }
        }.searchable(text: $searchFilter)
            .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
    }
}

struct TaskRowView: View {
    private let task: TaskData
    private let user: UserData
    
    @State var showDescription = false
    @State var icon = "chevron.right"
    
    init(task: TaskData, user: UserData) {
        self.task = task
        self.user = user
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
                Spacer()
                
                if !(task.description ?? "").isEmpty {
                    Button {
                        showDescription.toggle()
                        
                        withAnimation(.interactiveSpring) {
                            if !showDescription {
                                icon = "chevron.right"
                            } else {
                                icon = "chevron.down"
                            }
                        }
                    } label:{
                        Image(systemName: icon)
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
