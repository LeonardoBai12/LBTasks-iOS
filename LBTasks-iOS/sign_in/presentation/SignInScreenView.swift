//
//  SignInScreenView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import SwiftUI

struct SignInScreenView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var repeatedPassword = ""
    
    @State private var showAlert = false
    @State private var errorMessage = "Unknown error"
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Repeat Password", text: $repeatedPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            
            Button("Sign In with Email") {
                viewModel.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                    repeatedPassword: repeatedPassword
                )
            }
            
            Button("Login with Email") {
                viewModel.loginWithEmailAndPassword(email: email, password: password)
            }
            Button("Show current user") {
                errorMessage = viewModel.getSignedInUser()?.email ?? "No user"
                showAlert = true
            }
            Button("Logout") {
                viewModel.logout()
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text(errorMessage)
            )
        }
        .onReceive(viewModel.$state) { state in
            if let signInError = state.signInError {
                errorMessage = signInError
                showAlert = true
            }
        }
    }
}
