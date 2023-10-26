//
//  TaskType.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

enum TaskType: String {
    case home
    case business
    case study
    case hobbies
    case shopping
    case travel
}

extension TaskType {
    func getImageName() -> String {
        var imageName: String

        switch self {
            case .home: imageName = "house.fill"
            case .business: imageName = "briefcase.fill"
            case .study: imageName = "graduationcap.fill"
            case .hobbies: imageName = "gamecontroller.fill"
            case .shopping: imageName = "cart.fill"
            case .travel: imageName = "airplane"
        }

        return imageName
    }

    func getName() -> String {
        var imageName: String

        switch self {
            case .home: imageName = "HOME"
            case .business: imageName = "BUSINESS"
            case .study: imageName = "STUDY"
            case .hobbies: imageName = "HOBBIES"
            case .shopping: imageName = "SHOPPING"
            case .travel: imageName = "TRAVEL"
        }

        return imageName
    }
}

extension String {
    func getTaskTypeByName() -> TaskType? {
        var taskType: TaskType?

        switch self {
            case "HOME": taskType = .home
            case "BUSINESS": taskType = .business
            case "STUDY": taskType = .study
            case "HOBBIES": taskType = .hobbies
            case "SHOPPING": taskType = .shopping
            case "TRAVEL": taskType = .travel
            default: taskType = nil
        }

        return taskType
    }
}
