//
//  TaskDependencies.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

class TaskDependencies {
    private let realtimeDatabaseClient = RealtimeDatabaseClient()
    let taskRepository: TaskRepository
    let taskUseCases: TaskUseCases

    init() {
        taskRepository = TaskRepositoryImpl(realtimeDatabaseClient: realtimeDatabaseClient)
        taskUseCases = TaskUseCases(
            deleteTaskUseCase: DeleteTaskUseCase(repository: taskRepository),
            getTasksUseCase: GetTasksUseCase(repository: taskRepository),
            insertTaskUseCase: InsertTaskUseCase(repository: taskRepository),
            updateTaskUseCase: UpdateTaskUseCase(repository: taskRepository)
        )
    }

    func makeTaskViewModel() -> TaskViewModel {
        return TaskViewModel(useCases: taskUseCases)
    }

    func makeTaskDetailsViewModel() -> TaskDetailsViewModel {
        return TaskDetailsViewModel(useCases: taskUseCases)
    }
}
