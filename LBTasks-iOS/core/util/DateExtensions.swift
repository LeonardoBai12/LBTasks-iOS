//
//  DateExtensions.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 22/10/23.
//

import Foundation

extension Date {
    func asTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    func asDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
