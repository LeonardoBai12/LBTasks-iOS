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
        let googleAuthUiClient = GoogleAuthUiClient()
        let signInRepository: SignInRepository = SignInRepositoryImpl(googleAuthUiClient: googleAuthUiClient)
        let signInUseCases = SignInUseCases(
            loginWithEmailPasswordUseCase: LoginWithEmailPasswordUseCase(repository: signInRepository),
            signInWithEmailPasswordUseCase: SignInWithEmailPasswordUseCase(repository: signInRepository),
            getSignedInUserUseCase: GetSignedInUserUseCase(repository: signInRepository),
            logoutUseCase: LogoutUseCase(repository: signInRepository)
        )
        let viewModel = SignInViewModel(useCases: signInUseCases)
        
        WindowGroup {
            NavigationView {
                SignInScreenView(viewModel: viewModel)
            }
        }
    }
}
