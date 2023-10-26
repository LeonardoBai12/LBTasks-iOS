//
//  MainView.swift
//  LBTasks-iOS
//
//  Created by Leonardo Bai on 21/10/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Text("Favourites Screen")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourites")
            }
            Text("Friends Screen")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Friends")
            }
            Text("Nearby Screen")
                .tabItem {
                    Image(systemName: "mappin.circle.fill")
                    Text("Nearby")
            }
        }
    }
}

#Preview {
    MainView()
}
