//
//  LogoutUseCase.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

class LogoutUseCase {
    private let repository: SignInRepository

    init(repository: SignInRepository) {
        self.repository = repository
    }

    func invoke() {
        repository.logout()
    }
}
