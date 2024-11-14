//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var loginError: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Restaurant POS")
                    .font(.largeTitle)
                    .padding(.top, 50)

                TextField("Username", text: $username)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)

                SecureField("Passwort", text: $password)
                    .textContentType(.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                Button(action: {
                    isLoggingIn = true
                    loginError = nil
                    viewModel.login(username: username, password: password) { success, error in
                        isLoggingIn = false
                        if success {
                        } else {
                            loginError = error ?? "Unbekannter Fehler"
                        }
                    }
                }) {
                    if isLoggingIn {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                .disabled(isLoggingIn || username.isEmpty || password.isEmpty)

                Spacer()
            }
            .navigationTitle("Login")
        }
    }
}
