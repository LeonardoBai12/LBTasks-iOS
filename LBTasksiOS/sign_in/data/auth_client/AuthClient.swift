//
//  GoogleAuthUiClient.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import FirebaseAuth
import AuthenticationServices

class AuthClient {
    private let auth = Auth.auth()

    func loginWithEmailAndPassword(email: String, password: String, completion: @escaping (SignInResult) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error)
                completion(SignInResult(data: nil, errorMessage: error.localizedDescription))
            } else if let user = authResult?.user {
                let userData = UserData(
                    userId: user.uid,
                    userName: user.displayName,
                    email: user.email,
                    profilePictureUrl: user.photoURL?.absoluteString
                )
                completion(SignInResult(data: userData, errorMessage: nil))
            }
        }
    }

    func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (SignInResult) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error)
                completion(SignInResult(data: nil, errorMessage: error.localizedDescription))
            } else if let user = authResult?.user {
                let userData = UserData(
                    userId: user.uid,
                    userName: user.displayName,
                    email: user.email,
                    profilePictureUrl: user.photoURL?.absoluteString
                )
                completion(SignInResult(data: userData, errorMessage: nil))
            }
        }
    }

    func getSignedInUser() -> UserData? {
        if let user = auth.currentUser {
            return UserData(
                userId: user.uid,
                userName: user.displayName,
                email: user.email,
                profilePictureUrl: user.photoURL?.absoluteString
            )
        }
        return nil
    }

    func logout() {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
