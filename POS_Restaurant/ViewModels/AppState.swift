//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//


import Foundation
import Combine
import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var isAuthenticated: Bool = false

    @AppStorage("authToken") var authToken: String?
    @AppStorage("authTokenExpiration") var authTokenExpiration: Date?

    private init() {
        checkAuthentication()
    }

    func checkAuthentication() {
         if let token = authToken,
            let expiration = authTokenExpiration,
            Date() < expiration {
             DispatchQueue.main.async {
                 self.isAuthenticated = true
                 print(self.isAuthenticated)
             }
         } else {
             DispatchQueue.main.async {
                 self.isAuthenticated = false
                 self.authToken = nil
                 self.authTokenExpiration = nil
                 print(self.isAuthenticated)
             }
         }
     }

    func logout() {
        isAuthenticated = false
        authToken = nil
        authTokenExpiration = nil
    }
}
