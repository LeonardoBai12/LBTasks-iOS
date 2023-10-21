//
//  TaskScreenView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import SwiftUI

struct TaskScreenView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var searchFilter = ""
    
    init(
        viewModel: TaskViewModel,
        userData: UserData
    ) {
        self.viewModel = viewModel
        viewModel.userData = userData
    }
    
    var filteredTasks: [TaskData] {
        if searchFilter.isEmpty {
            return viewModel.state.tasks
        } else {
            return viewModel.state.tasks.filter { task in
                let titleMatches = task.title.contains(searchFilter)
                let descriptionMatches = task.description?.contains(searchFilter) ?? false
                return titleMatches || descriptionMatches
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search tasks", text: $searchFilter)
                    .padding()
                
                Button("Get Tasks") {
                    if let userData = viewModel.userData {
                        viewModel.getTasks(userData: userData)
                    }
                }
                .padding()
                
                List(viewModel.state.tasks, id: \.uuid) { task in
                    HStack {
                        Text(task.title)
                        Spacer()

                        NavigationLink(
                            "Task Details",
                            destination: TaskDetailsScreenView(
                                viewModel: TaskDependencies().makeTaskDetailsViewModel(user: viewModel.userData!),
                                task: task
                            )
                        )
                    }
                }
            }
        }
        .navigationBarTitle("Task List")
    }
}
