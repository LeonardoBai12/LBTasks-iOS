//
//  SignInRepositoryImpl.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

class SignInRepositoryImpl: SignInRepository {
    private let authClient: AuthClient

    init(authClient: AuthClient) {
        self.authClient = authClient
    }

    func getSignedInUser() -> UserData? {
        return authClient.getSignedInUser()
    }

    func signInWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (SignInResult) -> Void
    ) {
        authClient.signInWithEmailAndPassword(email: email, password: password) { result in
            completion(result)
        }
    }

    func loginWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (SignInResult) -> Void
    ) {
        authClient.loginWithEmailAndPassword(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func signInWithGoogle(completion: @escaping (SignInResult) -> Void) {
        authClient.signInWithGoogle { result in
            completion(result)
        }
    }

    func logout() {
        authClient.logout()
    }
}
