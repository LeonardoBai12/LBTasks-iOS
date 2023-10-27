//
//  SignInWithGoogleUseCase.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 26/10/23.
//

import Foundation

class SignInWithGoogleUseCase {
    private let repository: SignInRepository

    init(repository: SignInRepository) {
        self.repository = repository
    }

    func invoke(completion: @escaping (SignInResult) -> Void) {
        repository.signInWithGoogle(completion: completion)
    }
}
