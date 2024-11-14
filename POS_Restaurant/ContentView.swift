//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            appState.checkAuthentication()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            TableView()
                .tabItem {
                    Image(systemName: "square.grid.3x3.fill")
                    Text("Tische")
                }
            OrderView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Bestellungen")
                }
        }
    }
}
