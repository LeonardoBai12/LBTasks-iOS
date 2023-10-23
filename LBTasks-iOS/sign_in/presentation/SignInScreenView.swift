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
    
    @State private var showLoginSheet = false
    @State private var showSignInSheet = false
    
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
        ZStack {
            GeometryReader { geometry in
                Image("login_background")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
            }
            
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.black,
                        Color.clear,
                        Color.black
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                LBTasksLogo(tint: .white)
                
                Spacer()
                
                Button {
                    showLoginSheet.toggle()
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .padding(.vertical, 8)
                }.buttonStyle(.borderedProminent)
                    .padding()
                
                Button(
                    action: {
                        showSignInSheet.toggle()
                    },
                    label: {
                        Text("Sign in")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .padding(.vertical, 8)
                            .foregroundStyle(.black)
                    }
                )
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .padding(.bottom, 32)
                .padding(.horizontal)
                
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
        .onReceive(viewModel.$state) { state in
            if state.isSignInSuccessful {
                showAlert = false
                isNavigationActive = true
            } else if let signInError = state.signInError {
                errorMessage = signInError
                showAlert = true
            }
        }
        .sheet(isPresented: $showLoginSheet) {
            SignInLoginView(
                isLogin: true,
                email: $email,
                password: $password,
                repeatedPassword: $repeatedPassword,
                viewModel: viewModel
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Something went wrong"),
                    message: Text(errorMessage)
                )
            }
        }
        .sheet(isPresented: $showSignInSheet) {
            SignInLoginView(
                isLogin: false,
                email: $email,
                password: $password,
                repeatedPassword: $repeatedPassword,
                viewModel: viewModel
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Something went wrong"),
                    message: Text(errorMessage)
                )
            }
        }
    }
}

struct LBTasksLogo: View {
    let tint: Color
    
    var body: some View {
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
                .foregroundStyle(tint)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
        }.padding(.all, 32)
    }
}

struct SignInLoginView: View {
    let isLogin: Bool
    let email: Binding<String>
    let password: Binding<String>
    let repeatedPassword: Binding<String>
    let viewModel: SignInViewModel
    
    var body: some View {
        LBTasksLogo(tint: .primary)
        
        DefaultTextField(
            placeholder: "Email",
            value: email,
            imageName: "envelope.fill"
        )
        DefaultTextField(
            placeholder: "Password",
            value: password,
            imageName: "lock.fill",
            isPassword: true
        )
        
        if !isLogin {
            DefaultTextField(
                placeholder: "Repeat password",
                value: repeatedPassword,
                imageName: "lock.fill",
                isPassword: true
            )
            
            Button {
                viewModel.signInWithEmailAndPassword(
                    email: email.wrappedValue,
                    password: password.wrappedValue,
                    repeatedPassword: repeatedPassword.wrappedValue
                )
            } label: {
                Text("Sign in")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }.buttonStyle(.borderedProminent)
                .padding(.bottom)
                .padding(.horizontal)
        } else {
            Button {
                viewModel.loginWithEmailAndPassword(
                    email: email.wrappedValue,
                    password: password.wrappedValue
                )
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }.buttonStyle(.borderedProminent)
                .padding(.bottom)
                .padding(.horizontal)
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
