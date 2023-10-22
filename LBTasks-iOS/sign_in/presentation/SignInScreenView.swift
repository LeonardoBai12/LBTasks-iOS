//
//  SignInScreenView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import SwiftUI

struct SignInScreenView: View {
    @ObservedObject var viewModel: SignInViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var taskDetailsViewModel: TaskDetailsViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var repeatedPassword = ""
    
    @State private var showAlert = false
    @State private var errorMessage = "Unknown error"
    
    @State private var isNavigationActive = false
    
    init(
        viewModel: SignInViewModel,
        taskViewModel: TaskViewModel,
        taskDetailsViewModel: TaskDetailsViewModel
    ) {
        self.viewModel = viewModel
        self.taskViewModel = taskViewModel
        self.taskDetailsViewModel = taskDetailsViewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Image(systemName: "note.text")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.white)
                        .opacity(0.9)
                        .frame(width: 50, height: 50)
                        .background(.tint)
                        .cornerRadius(15)
                    
                    Text("LB Tasks")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
                
                Spacer()
                
                DefaultTextField(
                    placeholder: "Email",
                    value: $email,
                    imageName: "envelope.fill"
                )
                DefaultTextField(
                    placeholder: "Password",
                    value: $password,
                    imageName: "lock.fill",
                    isPassword: true
                )
                DefaultTextField(
                    placeholder: "Repeat password",
                    value: $repeatedPassword,
                    imageName: "lock.fill",
                    isPassword: true
                )
                
                Button {
                    viewModel.loginWithEmailAndPassword(
                        email: email,
                        password: password
                    )
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .padding(.vertical, 8)
                }.buttonStyle(.borderedProminent)
                    .padding(.bottom)
                
                Button {
                    viewModel.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                        repeatedPassword: repeatedPassword
                    )
                } label: {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .padding(.vertical, 8)
                }.buttonStyle(.bordered)
                    .padding(.bottom)
            }
            .fullScreenCover(
                isPresented: $isNavigationActive
            ) {
                TaskScreenView(
                    viewModel: taskViewModel,
                    taskDetailsViewModel: taskDetailsViewModel,
                    userData: viewModel.getSignedInUser(),
                    logout: {
                        viewModel.logout()
                    }
                )
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
            if state.isSignInSuccessful {
                showAlert = false
                isNavigationActive = true
            } else if let signInError = state.signInError {
                errorMessage = signInError
                showAlert = true
            }
        }
    }
}

struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let taskViewModel = TaskDependencies().makeTaskViewModel()
        let signInViewModel = SignInDependencies().makeSignInViewModel()
        let taskDetailsViewModel = TaskDependencies().makeTaskDetailsViewModel()
        
        return SignInScreenView(
            viewModel: signInViewModel,
            taskViewModel: taskViewModel,
            taskDetailsViewModel: taskDetailsViewModel
        )
    }
}
