//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMenuItems() {
        guard let url = URL(string: "http:/192.168.178.156/api/menu") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [MenuItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching menu items: \(error)")
                }
            }, receiveValue: { [weak self] items in
                self?.menuItems = items
            })
            .store(in: &cancellables)
    }
}
