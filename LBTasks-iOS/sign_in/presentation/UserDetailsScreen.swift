//
//  UserDetailsScreen.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 21/10/23.
//

import SwiftUI

struct UserDetailsScreen: View {
    private let user: UserData
    private let logout: () -> Void

    @State var goToSignIn = false

    init(
        user: UserData,
        logout: @escaping () -> Void
    ) {
        self.user = user
        self.logout = logout
    }

    var body: some View {
        NavigationStack {
            VStack {
                if (user.profilePictureUrl  ?? "").isEmpty {
                    Text(user.email?.first?.uppercased() ?? "")
                        .foregroundStyle(.tint)
                        .font(.system(size: 100))
                        .frame(maxWidth: 200, maxHeight: 200)
                        .background(.tertiary)
                        .clipShape(Circle())
                        .padding()
                } else {
                    AsyncImage(
                        url: URL(string: user.profilePictureUrl ?? ""),
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 200, maxHeight: 200)
                                .clipShape(Circle())
                        },
                        placeholder: {
                            ProgressView()
                                .frame(maxWidth: 200, maxHeight: 200)
                        }
                    ).padding()
                }

                Text(user.userName ?? "")
                    .font(.largeTitle)
                    .bold()
                Text(user.email ?? "")
                    .font(.headline)

                Spacer()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        logout()
                        goToSignIn.toggle()
                    } label: {
                        Text("Logout")
                    }
                }
            }
        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .fullScreenCover(
                isPresented: $goToSignIn
            ) {
                let taskDependencies = TaskDependencies()

                SignInScreenView(
                    viewModel: SignInDependencies().makeSignInViewModel(),
                    taskViewModel: taskDependencies.makeTaskViewModel(),
                    taskDetailsViewModel: taskDependencies.makeTaskDetailsViewModel()
                )
            }
    }
}

#Preview {
    UserDetailsScreen(
        user: UserData(
            userId: "",
            userName: "Example User",
            email: "example@email.com",
            profilePictureUrl: ""
        ),
        logout: { }
    )
}
