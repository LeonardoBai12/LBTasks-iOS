//
//  GoogleAuthUiClient.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import FirebaseCore

class AuthClient {
    private let auth = Auth.auth()
    private let googleSignIn = GIDSignIn.sharedInstance

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
    
    func signInWithGoogle(completion: @escaping (SignInResult) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
     
        let config = GIDConfiguration(clientID: clientID)
        googleSignIn.configuration = config
        
        googleSignIn.signIn(
            withPresenting: ApplicationUtils.rootViewController
        ) { user, error in
            if let error = error {
                completion(
                    SignInResult(
                        data: nil,
                        errorMessage: error.localizedDescription
                    )
                )
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else {
                
                completion(
                    SignInResult(
                        data: nil,
                        errorMessage: "No user token found for this account."
                    )
                )
                return
            }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            
            self.auth.signIn(with: credential) { res, error in
                if let error = error {
                    completion(
                        SignInResult(
                            data: nil,
                            errorMessage: error.localizedDescription
                        )
                    )
                    return
                }
                
                guard let user = res?.user else {
                    completion(
                        SignInResult(
                            data: nil,
                            errorMessage: "No user found for this account."
                        )
                    )
                    return
                }
                
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
