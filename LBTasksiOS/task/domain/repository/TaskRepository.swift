//
//  TaskRepository.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation
import Combine

protocol TaskRepository {
    func deleteTask(userData: UserData, task: TaskData)
    func getTasks(userData: UserData) -> AnyPublisher<[TaskData], Error>
    func insertTask(userData: UserData, task: TaskData)
}
