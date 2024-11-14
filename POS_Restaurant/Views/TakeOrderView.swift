//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//


import SwiftUI

struct TakeOrderView: View {
    let table: Table
    @StateObject private var menuViewModel = MenuViewModel()
    @State private var selectedOrderItems: [OrderItem] = []
    @State private var notes: String = ""
    @Environment(\.dismiss) private var dismiss

    @AppStorage("authToken") private var authToken: String?
    @AppStorage("apiEndpoint") private var apiEndpoint: String = "http://192.168.178.156"

    var body: some View {
        VStack {
            Text("Bestellung für \(table.name)")
                .font(.largeTitle)
                .padding()

            List(menuViewModel.menuItems) { item in
                MenuItemRow(menuItem: item, selectedOrderItems: $selectedOrderItems)
            }

            TextField("Notizen", text: $notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()

            Button(action: {
                submitOrder()
            }) {
                Text("Bestellung aufgeben")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            menuViewModel.fetchMenuItems()
        }
        .navigationBarItems(trailing: Button("Schließen") {
            dismiss()
        })
    }

    private func submitOrder() {

        guard !selectedOrderItems.isEmpty else {
            print("Es wurden keine Artikel zur Bestellung hinzugefügt.")
            return
        }

        let totalAmount = selectedOrderItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }

        let order = Order(
            id: nil,
            tableNumber: table.number,
            staffId: 1, 
            notes: notes,
            orderItems: selectedOrderItems,
            totalAmount: totalAmount,
            status: nil,
            orderTime: Date()
        )

        guard let url = URL(string: "\(apiEndpoint)/api/orders") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Kein Authentifizierungs-Token gefunden.")
            return
        }

        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(order)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Fehler beim Kodieren der Bestellung: \(error)")
            return
        }

        if let requestBodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) {
            print("Request Body: \(requestBodyString)")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fehler beim Senden der Bestellung: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Serverantwort Statuscode: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Serverantwort Inhalt: \(responseString)")
                }
                if (200...299).contains(httpResponse.statusCode) {
                    print("Bestellung erfolgreich gesendet")
                    DispatchQueue.main.async {
                        self.selectedOrderItems = []
                        self.notes = ""
                        dismiss()
                    }
                } else {
                    print("Serverantwort Fehler: \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()
    }
}
