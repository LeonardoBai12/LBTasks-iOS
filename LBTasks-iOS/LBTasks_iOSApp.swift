//
//  LBTasks_iOSApp.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 15/10/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LBTasks_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        let dependencies = SignInDependencies().makeSignInViewModel()
        let taskDependencies = TaskDependencies()
        
        WindowGroup {
            NavigationView {
                SignInScreenView(
                    viewModel: dependencies,
                    destination: TaskScreenView(
                        viewModel: taskDependencies.makeTaskViewModel(),
                        userData: dependencies.getSignedInUser()!
                    )
                )
            }
        }
    }
}
