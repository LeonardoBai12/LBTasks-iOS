//
//  Task.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

struct TaskData {
    let uuid: String
    var title: String
    var description: String?
    let taskType: String
    var deadlineDate: String?
    var deadlineTime: String?
    
    init(
        uuid: String = UUID().uuidString,
        title: String,
        description: String? = nil,
        taskType: String,
        deadlineDate: String? = nil,
        deadlineTime: String? = nil
    ) {
        self.uuid = uuid
        self.title = title
        self.description = description
        self.taskType = taskType
        self.deadlineDate = deadlineDate
        self.deadlineTime = deadlineTime
    }
    
    static func fromSnapshot(dictionary: [String: String]) -> TaskData {
        return TaskData(
            uuid: dictionary["uuid"] ?? "",
            title: dictionary["title"] ?? "",
            description: dictionary["description"],
            taskType: dictionary["taskType"] ?? "",
            deadlineDate: dictionary["deadlineDate"],
            deadlineTime: dictionary["deadlineTime"]
        )
    }
}

extension TaskData {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "uuid": uuid,
            "title": title,
            "taskType": taskType
        ]
        
        if let description = description {
            dictionary["description"] = description
        }
        
        if let deadlineDate = deadlineDate {
            dictionary["deadlineDate"] = deadlineDate
        }
        
        if let deadlineTime = deadlineTime {
            dictionary["deadlineTime"] = deadlineTime
        }
        
        return dictionary
    }
}
