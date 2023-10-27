//
//  SignInViewModel.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import Foundation

import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    @Published var state = SignInState()
    private let useCases: SignInUseCases

    init(useCases: SignInUseCases) {
        self.useCases = useCases
    }

    func signInWithEmailAndPassword(email: String, password: String, repeatedPassword: String) {
        useCases.signInWithEmailPasswordUseCase.invoke(
            email: email,
            password: password,
            repeatedPassword: repeatedPassword
        ) { result in
            self.onSignInResult(result)
        }
    }

    func loginWithEmailAndPassword(email: String, password: String) {
        useCases.loginWithEmailPasswordUseCase.invoke(
            email: email,
            password: password
        ) { result in
            self.onSignInResult(result)
        }
    }

    func signInWithGoogle() {
        useCases.signInWithGoogleUseCase.invoke { result in
            self.onSignInResult(result)
        }
    }
    
    func getSignedInUser() -> UserData? {
        return useCases.getSignedInUserUseCase.invoke()
    }

    func logout() {
        useCases.logoutUseCase.invoke()
    }

    func resetState() {
        state = SignInState()
    }

    private func onSignInResult(_ result: SignInResult) {
        state.isSignInSuccessful = result.data != nil
        state.signInError = result.errorMessage
    }
}
