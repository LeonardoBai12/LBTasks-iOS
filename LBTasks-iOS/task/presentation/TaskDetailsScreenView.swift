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
    
    private var isEdit = false
    private let onDone: () -> Void
    
    private var user: UserData

    init(
        viewModel: TaskDetailsViewModel,
        task: TaskData?,
        user: UserData,
        onDone: @escaping () -> Void
    ) {
        editedTitle = task?.title ?? ""
        editedDescription = task?.description ?? ""
        editedDate = task?.deadlineDate ?? ""
        editedTime = task?.deadlineTime ?? ""
        
        isEdit = task != nil
        
        self.onDone = onDone
        self.viewModel = viewModel
        self.user = user
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Task Title", text: $editedTitle)
                TextField("Task Description", text: $editedDescription)
                TextField("Task Deadline Date", text: $editedDate)
                TextField("Task Deadline Time", text: $editedTime)
            }
            .navigationBarTitle("Task Details")
            .toolbar {
                ToolbarItem {
                    Button {
                        if isEdit {
                            viewModel.onRequestUpdate(
                                userData: user,
                                title: editedTitle,
                                description: editedDescription,
                                date: editedDate,
                                time: editedTime
                            )
                        } else {
                            viewModel.onRequestInsert(
                                userData: user,
                                title: editedTitle,
                                description: editedDescription,
                                date: editedDate,
                                time: editedTime
                            )
                        }
                        
                        onDone()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
