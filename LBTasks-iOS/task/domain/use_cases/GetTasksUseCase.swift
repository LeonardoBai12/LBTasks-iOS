//
//  GetTaskUseCase.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation
import Combine

class GetTasksUseCase {
    private let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func invoke(userData: UserData) -> AnyPublisher<[TaskData], Error> {
        return repository.getTasks(userData: userData)
    }
}
