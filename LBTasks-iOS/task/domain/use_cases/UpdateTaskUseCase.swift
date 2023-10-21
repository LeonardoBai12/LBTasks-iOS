//
//  UpdateTaskUseCases.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

class UpdateTaskUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func invoke(
        userData: UserData,
        originalTask: TaskData,
        title: String,
        description: String,
        taskType: String,
        deadlineDate: String,
        deadlineTime: String
    ) throws {
        if title.isEmpty {
            throw NSError(domain: "lb.io", code: 1, userInfo: [NSLocalizedDescriptionKey: "You can't save without a title"])
        }
        
        let updatedTask = TaskData(
            uuid: originalTask.uuid,
            title: title,
            description: description,
            taskType: taskType,
            deadlineDate: deadlineDate.replacingOccurrences(of: "/", with: "-"),
            deadlineTime: deadlineTime
        )
        
        try repository.insertTask(userData: userData, task: updatedTask)
    }
}
