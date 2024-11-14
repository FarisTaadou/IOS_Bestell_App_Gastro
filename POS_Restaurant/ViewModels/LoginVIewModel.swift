//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//


import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @AppStorage("apiEndpoint") private var apiEndpoint: String = "http://192.168.178.156"
    @AppStorage("authToken") var authToken: String?
    @AppStorage("authTokenExpiration") var authTokenExpiration: Date?


    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(apiEndpoint)/api/login") else {
            completion(false, "Ungültiger API-Endpunkt")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let loginData = ["username": username, "password": password]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(false, "Fehler beim Kodieren der Anmeldedaten")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Netzwerkfehler: \(error.localizedDescription)")
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, "Ungültige Serverantwort")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, "Keine Daten empfangen")
                }
                return
            }

            if httpResponse.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let token = json?["token"] as? String {
                        DispatchQueue.main.async {
                            print("Erhaltener Token: \(token)") // Debug-Ausgabe
                            self.authToken = token
                            self.authTokenExpiration = Calendar.current.date(byAdding: .day, value: 1, to: Date()) //1 Tag speichern
                            AppState.shared.isAuthenticated = true
                            
                            completion(true, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(false, "Ungültiger Token empfangen")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, "Fehler beim Verarbeiten der Serverantwort")
                    }
                }
            } else {
                // Behandle Serverfehlermeldungen, falls vorhanden
                let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                DispatchQueue.main.async {
                    completion(false, "Serverfehler: \(message)")
                }
            }
        }.resume()
    }
}
