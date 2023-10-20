//
//  SignInResult.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

struct SignInResult {
    var data: UserData?
    var errorMessage: String?

    init(data: UserData?, errorMessage: String? = nil) {
        self.data = data
        self.errorMessage = errorMessage
    }
}
