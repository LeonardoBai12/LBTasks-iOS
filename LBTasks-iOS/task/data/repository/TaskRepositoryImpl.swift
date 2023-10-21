//
//  TaskRepositoryImpl.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation
import Combine

class TaskRepositoryImpl: TaskRepository {
    private let realtimeDatabaseClient: RealtimeDatabaseClient
    
    init(realtimeDatabaseClient: RealtimeDatabaseClient) {
        self.realtimeDatabaseClient = realtimeDatabaseClient
    }
    
    func deleteTask(userData: UserData, task: TaskData) {
        realtimeDatabaseClient.deleteTask(user: userData, task: task)
    }
    
    func getTasks(userData: UserData) -> AnyPublisher<[TaskData], Error> {
        return Future<[TaskData], Error> { promise in
            self.realtimeDatabaseClient.getTasksFromUser(user: userData) { tasks in
                promise(Result { tasks })
            }
        }.eraseToAnyPublisher()
    }
    
    func insertTask(userData: UserData, task: TaskData) {
        realtimeDatabaseClient.insertTask(user: userData, task: task)
    }
}
