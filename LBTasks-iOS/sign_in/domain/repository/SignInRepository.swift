//
//  SignInRepository.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import UIKit

protocol SignInRepository {
    func getSignedInUser() -> UserData?
    func signInWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (SignInResult) -> Void
    )
    func loginWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (SignInResult) -> Void
    )
    func logout()
}
