//
//  LBTasksiOSApp.swift
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
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct LBTasksiOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        let signInViewModel = SignInDependencies().makeSignInViewModel()
        let taskDependencies = TaskDependencies()
        let taskViewModel = taskDependencies.makeTaskViewModel()
        let user = signInViewModel.getSignedInUser()
        let taskDetailsViewModel = taskDependencies.makeTaskDetailsViewModel()

        let taskScreen = TaskScreenView(
            viewModel: taskViewModel,
            taskDetailsViewModel: taskDetailsViewModel,
            userData: signInViewModel.getSignedInUser(),
            logout: {
                signInViewModel.logout()
            }
        )

        let signInScreen = SignInScreenView(
            viewModel: signInViewModel,
            taskViewModel: taskViewModel,
            taskDetailsViewModel: taskDetailsViewModel
        )

        WindowGroup {
            NavigationView {
                if user != nil {
                    taskScreen
                } else {
                    signInScreen
                }
            }
        }
    }
}
