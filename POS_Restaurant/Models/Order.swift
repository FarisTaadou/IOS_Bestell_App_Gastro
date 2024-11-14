//
//  Order.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import Foundation

struct Order: Codable, Identifiable {
    let id: Int?
    let tableNumber: Int
    let staffId: Int
    let notes: String?
    let orderItems: [OrderItem]
    let totalAmount: Double?
    let status: String?
    let orderTime: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case tableNumber = "table_number"
        case staffId = "staff_id"
        case notes
        case orderItems = "order_items"
        case totalAmount = "total_amount"
        case status
        case orderTime = "order_time"
    }
}
