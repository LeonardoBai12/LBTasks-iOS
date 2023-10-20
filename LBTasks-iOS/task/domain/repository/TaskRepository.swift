//
//  TaskRepository.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

protocol TaskRepository {
    func deleteTask(userData: UserData, task: TaskData, completion: @escaping (Error?) -> Void)
    func insertTask(userData: UserData, task: TaskData, completion: @escaping (Error?) -> Void)
}
