//
//  LoginWIthEmailAndPasswordUseCase.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

class LoginWithEmailPasswordUseCase {
    private let repository: SignInRepository

    init(repository: SignInRepository) {
        self.repository = repository
    }

    func invoke(email: String, password: String, completion: @escaping (SignInResult) -> Void) {
        guard email.isValidEmail() else {
            completion(SignInResult(data: nil, errorMessage: "Write a valid email"))
            return
        }

        guard !password.isEmpty else {
            completion(SignInResult(data: nil, errorMessage: "Write your password"))
            return
        }

        repository.loginWithEmailAndPassword(email: email, password: password, completion: completion)
    }
}
