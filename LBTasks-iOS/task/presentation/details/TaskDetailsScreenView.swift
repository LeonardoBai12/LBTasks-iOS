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
    private var navigationTitle = "New task"
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
        
        if isEdit {
            navigationTitle = task!.title
        }
        
        self.onDone = onDone
        self.viewModel = viewModel
        self.user = user
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        Text("Select a task type")
                            .padding(.bottom)
                        
                        HStack {
                            Spacer()
                            Image(systemName: TaskType.business.getImageName())
                            Spacer()
                            Image(systemName: TaskType.hobbies.getImageName())
                            Spacer()
                            Image(systemName: TaskType.home.getImageName())
                            Spacer()
                        }.padding(.bottom, 40)
                        
                        HStack {
                            Spacer()
                            Image(systemName: TaskType.shopping.getImageName())
                            Spacer()
                            Image(systemName: TaskType.study.getImageName())
                            Spacer()
                            Image(systemName: TaskType.travel.getImageName())
                            Spacer()
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
                    TextField("Deadline Date", text: $editedDate)
                }
                Section {
                    TextField("Deadline Time", text: $editedTime)
                }
            }.navigationBarTitle(navigationTitle)
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
