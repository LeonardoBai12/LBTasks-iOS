//
//  SignInRepositoryImpl.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

class SignInRepositoryImpl: SignInRepository {
    private let googleAuthUiClient: AuthClient

    init(googleAuthUiClient: AuthClient) {
        self.googleAuthUiClient = googleAuthUiClient
    }

    func getSignedInUser() -> UserData? {
        return googleAuthUiClient.getSignedInUser()
    }

    func signInWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (SignInResult) -> Void
    ) {
        googleAuthUiClient.signInWithEmailAndPassword(email: email, password: password) { result in
            completion(result)
        }
    }

    func loginWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (SignInResult) -> Void
    ) {
        googleAuthUiClient.loginWithEmailAndPassword(email: email, password: password) { result in
            completion(result)
        }
    }

    func logout() {
        googleAuthUiClient.logout()
    }
}
