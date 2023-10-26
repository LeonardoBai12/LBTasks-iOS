//
//  SignInDependencies.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

class SignInDependencies {
    let googleAuthUiClient = AuthClient()
    let signInRepository: SignInRepository
    let signInUseCases: SignInUseCases

    init() {
        signInRepository = SignInRepositoryImpl(googleAuthUiClient: googleAuthUiClient)
        signInUseCases = SignInUseCases(
            loginWithEmailPasswordUseCase: LoginWithEmailPasswordUseCase(repository: signInRepository),
            signInWithEmailPasswordUseCase: SignInWithEmailPasswordUseCase(repository: signInRepository),
            getSignedInUserUseCase: GetSignedInUserUseCase(repository: signInRepository),
            logoutUseCase: LogoutUseCase(repository: signInRepository)
        )
    }

    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(useCases: signInUseCases)
    }
}
