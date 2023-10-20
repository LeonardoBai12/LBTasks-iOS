//
//  SignInWithEmailAndPasswordUseCase.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

class SignInWithEmailPasswordUseCase {
    private let repository: SignInRepository

    init(repository: SignInRepository) {
        self.repository = repository
    }

    func invoke(email: String, password: String, repeatedPassword: String, completion: @escaping (SignInResult) -> Void) {
        guard email.isValidEmail() else {
            completion(SignInResult(data: nil, errorMessage: "Write a valid email"))
            return
        }

        guard !password.isEmpty else {
            completion(SignInResult(data: nil, errorMessage: "Write your password"))
            return
        }

        guard password == repeatedPassword else {
            completion(SignInResult(data: nil, errorMessage: "The passwords don't match"))
            return
        }

        repository.signInWithEmailAndPassword(email: email, password: password, completion: completion)
    }
}
