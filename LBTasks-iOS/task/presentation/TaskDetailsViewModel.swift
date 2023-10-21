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
    
    var userData: UserData?
    
    init(useCases: TaskUseCases, user: UserData) {
        self.useCases = useCases
        self.userData = user
    }
    
    func onRequestInsert(title: String, description: String, date: String, time: String) {
        guard let userData = userData, let task = state.task else { return }
        
        do {
            try useCases.insertTaskUseCase.invoke(
                userData: userData,
                title: title,
                description: description,
                taskType: task.taskType,
                deadlineDate: date,
                deadlineTime: time
            )
        } catch {

        }
    }
    
    func onRequestUpdate(title: String, description: String, date: String, time: String) {
        guard let userData = userData, let task = state.task else { return }
        
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
        } catch {
                
        }
    }
}
