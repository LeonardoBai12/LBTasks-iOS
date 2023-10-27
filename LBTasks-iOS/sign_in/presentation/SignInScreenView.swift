//
//  SignInScreenView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 19/10/23.
//

import SwiftUI
import GoogleSignInSwift

struct SignInScreenView: View {
    @ObservedObject var viewModel: SignInViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    @ObservedObject var taskDetailsViewModel: TaskDetailsViewModel

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
                    LBTasksLogo(tint: .white, font: .largeTitle)
                        .padding(.all, 32)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: SignInLoginView(
                            viewModel: viewModel,
                            taskViewModel: taskViewModel,
                            taskDetailsViewModel: taskDetailsViewModel,
                            isLogin: true,
                            isGoogleSignIn: false
                        ),
                        label: {
                            LoginButtonView(label: "Login")
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .padding(.vertical, 8)
                        }
                    )
                    
                    NavigationLink(
                        destination: SignInLoginView(
                            viewModel: viewModel,
                            taskViewModel: taskViewModel,
                            taskDetailsViewModel: taskDetailsViewModel,
                            isLogin: false,
                            isGoogleSignIn: false
                        ),
                        label: {
                            SignInButtonView(label: "Sign in")
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .padding(.bottom, 8)
                        }
                    )
                    
                    Text("or")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    NavigationLink(
                        destination: SignInLoginView(
                            viewModel: viewModel,
                            taskViewModel: taskViewModel,
                            taskDetailsViewModel: taskDetailsViewModel,
                            isLogin: false,
                            isGoogleSignIn: true
                        ),
                        label: {
                            SignInWithGoogleButtonView()
                                .font(.title2)
                                .frame(maxWidth: .infinity, maxHeight: 60)
                                .background(.background)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.bottom, 24)
                        }
                    )
                }
            }        
            .onAppear {
                viewModel.state.signInError = ""
                viewModel.state.isSignInSuccessful = false
            }
        }
    }
}

struct LBTasksLogo: View {
    let tint: Color
    let font: Font

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
                .font(font)
                .foregroundStyle(tint)
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
        }
    }
}

struct LoginButtonView: View {
    let label: String

    var body: some View {
        Text(label)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(.tint)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

struct SignInButtonView: View {
    let label: String

    var body: some View {
        Text(label)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(.background)
            .foregroundColor(.accentColor)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

struct SignInWithGoogleButtonView: View {
    var body: some View {
        HStack {
            Image("google-icon")
                .resizable()
                .frame(width: 40, height: 40)
            Text("Sign in with Google")
                .foregroundColor(.primary)
        }
    }
}

struct SignInLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var viewModel: SignInViewModel
    var taskViewModel: TaskViewModel
    var taskDetailsViewModel: TaskDetailsViewModel

    let isLogin: Bool
    let isGoogleSignIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var repeatedPassword = ""

    @State private var showAlert = false
    @State private var errorMessage = "Unknown error"

    @State private var isNavigationActive = false

    var body: some View {
        let screen = NavigationView {
            if !isGoogleSignIn {
                VStack {
                    Form {
                        Section {
                            LBTasksLogo(tint: .primary, font: .title)
                                .padding(.all, 4)
                        }
                        
                        Section {
                            DefaultTextField(
                                placeholder: "Email",
                                value: $email,
                                imageName: "envelope.fill"
                            )
                        }
                        
                        Section {
                            DefaultTextField(
                                placeholder: "Password",
                                value: $password,
                                imageName: "lock.fill",
                                isPassword: true
                            )
                        }
                        
                        if !isLogin {
                            Section {
                                DefaultTextField(
                                    placeholder: "Repeat password",
                                    value: $repeatedPassword,
                                    imageName: "lock.fill",
                                    isPassword: true
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
            } else {
                EmptyView()
            }
        }
        .toolbar {
            if !isGoogleSignIn {
                ToolbarItem {
                    Button {
                        if !isLogin {
                            viewModel.signInWithEmailAndPassword(
                                email: email,
                                password: password,
                                repeatedPassword: repeatedPassword
                            )
                        } else {
                            viewModel.loginWithEmailAndPassword(
                                email: email,
                                password: password
                            )
                        }
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .onAppear {
            errorMessage = ""
            showAlert = false
            viewModel.state.signInError = ""
            viewModel.state.isSignInSuccessful = false
            
            if isGoogleSignIn {
                viewModel.signInWithGoogle()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Something went wrong"),
                message: Text(errorMessage)
            )
        }
        .onReceive(viewModel.$state) { state in
            if state.isSignInSuccessful {
                isNavigationActive = true
            } else if let signInError = state.signInError {
                if !signInError.isEmpty {
                    if isGoogleSignIn {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        errorMessage = signInError
                        showAlert = true
                    }
                }
            }
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
        
        if isGoogleSignIn {
            screen.navigationBarBackButtonHidden()
        } else {
            screen
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
