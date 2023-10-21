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

    init(viewModel: TaskDetailsViewModel, task: TaskData) {
        editedTitle = task.title
        editedDescription = task.description ?? ""
        editedDate = task.deadlineDate ?? ""
        editedTime = task.deadlineTime ?? ""
        
        self.viewModel = viewModel
        self.viewModel.state.task = task
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Task Title", text: $editedTitle)
                TextField("Task Description", text: $editedDescription)
                TextField("Task Deadline Date", text: $editedDate)
                TextField("Task Deadline Time", text: $editedTime)
                

                Spacer()
                
                Button("insert Task") {
                    viewModel.onRequestInsert(
                        title: editedTitle,
                        description: editedDescription,
                        date: editedDate,
                        time: editedTime
                    )
                }

                Button("Edit Task") {
                    viewModel.onRequestUpdate(
                        title: editedTitle,
                        description: editedDescription,
                        date: editedDate,
                        time: editedTime
                    )
                }
                .padding()
            }
            .navigationBarTitle("Task Details")
        }
    }
}
