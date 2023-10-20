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
}
