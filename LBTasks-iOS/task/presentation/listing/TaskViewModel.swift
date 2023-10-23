//
//  TaskViewModel.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 20/10/23.
//

import Foundation
import Combine
import SwiftUI

class TaskViewModel: ObservableObject {
    private let useCases: TaskUseCases
    
    @Published var state = TaskState()
    private var getTasksCancellable: AnyCancellable?
    
    var userData: UserData?
    private var recentlyDeletedTask: TaskData?
    
    init(useCases: TaskUseCases) {
        self.useCases = useCases
    }
    
    func onRequestDelete(task: TaskData) {
        deleteTask(task)
        recentlyDeletedTask = task
    }
    
    func onRestoreTask() {
        if let task = recentlyDeletedTask {
            restoreTask(task)
        }
    }
    
    func getTasks(userData: UserData) {
        getTasksCancellable?.cancel()
        getTasksCancellable = useCases.getTasksUseCase.invoke(userData: userData)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.state.tasks = data
            })
    }
    
    private func restoreTask(_ task: TaskData) {
        guard let userData = userData else { return }
        do {
            try useCases.insertTaskUseCase.invoke(
                userData: userData,
                title: task.title,
                description: task.description ?? "",
                taskType: task.taskType,
                deadlineDate: task.deadlineDate ?? "",
                deadlineTime: task.deadlineTime ?? ""
            )
        } catch let taskMessage as NSError {
            state.errorMessage = taskMessage.localizedDescription
        }
        getTasks(userData: userData)
    }
    
    private func deleteTask(_ task: TaskData) {
        guard let userData = userData else { return }
        useCases.deleteTaskUseCase.invoke(userData: userData, task: task)
        getTasks(userData: userData)
    }
    
    func clear() {
        state = TaskState()
    }
}
