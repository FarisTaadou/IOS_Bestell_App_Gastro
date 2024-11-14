//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//


import Foundation
import Combine
import SwiftUI

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var filter: OrderFilter = .current

    private var cancellables = Set<AnyCancellable>()

    enum OrderFilter {
        case current
        case finished
        case all
    }

    @AppStorage("apiEndpoint") private var apiEndpoint: String = "http://192.168.178.156"
    @AppStorage("authToken") private var authToken: String?

    func fetchOrders() {
        guard let url = URL(string: "\(apiEndpoint)/api/orders") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Kein Authentifizierungs-Token verfügbar.")
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Order].self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Fehler beim Abrufen der Bestellungen: \(error)")
                }
            }, receiveValue: { [weak self] orders in
                self?.orders = orders
            })
            .store(in: &cancellables)
    }

    var filteredOrders: [Order] {
        switch filter {
        case .current:
            return orders.filter { $0.status != "Abgeschlossen" }
        case .finished:
            return orders.filter { $0.status == "Abgeschlossen" }
        case .all:
            return orders
        }
    }
}
