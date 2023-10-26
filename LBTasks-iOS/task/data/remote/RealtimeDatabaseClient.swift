//
//  RealtimeDatabaseClient.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation
import FirebaseDatabase
import FirebaseCore

class RealtimeDatabaseClient {
    private var database: DatabaseReference = Database.database().reference().child("task")

    func insertTask(user: UserData, task: TaskData) {
        guard let userId = user.userId else {
            return
        }
        let taskReference = database.child(userId).child(task.id)
        taskReference.setValue(task.toDictionary())
    }

    func deleteTask(user: UserData, task: TaskData) {
        guard let userId = user.userId else {
            return
        }
        let taskReference = database.child(userId).child(task.id)
        taskReference.removeValue()
    }

    func getTasksFromUser(user: UserData, completion: @escaping ([TaskData]) -> Void) {
        guard let userId = user.userId else {
            completion([])
            return
        }

        database.child(userId).observeSingleEvent(of: .value) { snapshot, _ in
            var tasks: [TaskData] = []
            for case let child as DataSnapshot in snapshot.children {
                if let value = child.value as? [String: String] {
                    let task = TaskData.fromSnapshot(dictionary: value)
                    tasks.append(task)
                }
            }

            let sortedTasks = tasks.sorted {
                if $0.deadlineDate != $1.deadlineDate {
                    return $0.deadlineDate ?? "" < $1.deadlineDate ?? ""
                } else if $0.deadlineTime != $1.deadlineTime {
                    return $0.deadlineTime ?? "" < $1.deadlineTime ?? ""
                } else {
                    return $0.title < $1.title
                }
            }

            completion(sortedTasks)
        }
    }
}
