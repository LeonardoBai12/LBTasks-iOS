//
//  LBTasks_iOSApp.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 15/10/23.
//

import SwiftUI
import FirebaseCore

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
        let dependencies = SignInDependencies()
        
        WindowGroup {
            NavigationView {
                SignInScreenView(viewModel: dependencies.makeSignInViewModel())
            }
        }
    }
}
