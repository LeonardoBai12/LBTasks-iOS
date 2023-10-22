//
//  TaskState.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 20/10/23.
//

import Foundation
import Combine

struct TaskState {
    var tasks: [TaskData] = []
    var loading: Bool = true
    var errorMessage: String =  ""
}
