//
//  DeleteTaskUseCase.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

class DeleteTaskUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func invoke(userData: UserData, task: TaskData) {
        repository.deleteTask(userData: userData, task: task)
    }
}
