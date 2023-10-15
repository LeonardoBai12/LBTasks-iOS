//
//  LBTasks_iOSApp.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 15/10/23.
//

import SwiftUI

@main
struct LBTasks_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
