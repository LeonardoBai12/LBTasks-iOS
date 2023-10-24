//
//  TaskDetailsViewModel.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 20/10/23.
//

import Foundation
import SwiftUI
import Combine

class TaskDetailsViewModel: ObservableObject {
    private let useCases: TaskUseCases
    @Published var state = TaskDetailsState()
    
    init(useCases: TaskUseCases) {
        self.useCases = useCases
    }
    
    func onRequestInsert(
        userData: UserData,
        title: String,
        description: String,
        taskType: String,
        date: String,
        time: String
    ) {
        state.errorMessage = ""
        state.isTaskSaveSuccesful = false
        
        do {
            try useCases.insertTaskUseCase.invoke(
                userData: userData,
                title: title,
                description: description,
                taskType: taskType,
                deadlineDate: date,
                deadlineTime: time
            )
            state.isTaskSaveSuccesful = true
            state.errorMessage = ""
        } catch let errorMessage as NSError {
            state.errorMessage = errorMessage.localizedDescription
        }
    }
    
    func onRequestUpdate(
        userData: UserData,
        task: TaskData,
        title: String,
        description: String,
        date: String,
        time: String
    ) {
        state.errorMessage = ""
        state.isTaskSaveSuccesful = false
        
        do {
            try useCases.updateTaskUseCase.invoke(
                userData: userData,
                originalTask: task,
                title: title,
                description: description,
                taskType: task.taskType,
                deadlineDate: date,
                deadlineTime: time
            )
            state.isTaskSaveSuccesful = true
        } catch let errorMessage as NSError {
            state.errorMessage = errorMessage.localizedDescription
        }
    }
}
