//
//  OrderItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import Foundation

struct OrderItem: Codable, Identifiable {
    var id: Int { menuItemId }

    let menuItemId: Int
    var quantity: Int
    let price: Double
    var specialRequests: String?

    enum CodingKeys: String, CodingKey {
        case menuItemId = "menu_item_id"
        case quantity
        case price
        case specialRequests = "special_requests"
    }
}
