//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import Foundation

enum Category: String, Codable {
    case speisen = "Speisen"
    case getraenke = "Getränke"
    case hauptgericht = "Hauptgericht"
    case unbekannt

      init(from decoder: Decoder) throws {
          let container = try decoder.singleValueContainer()
          let rawValue = try container.decode(String.self)
          if let category = Category(rawValue: rawValue) {
              self = category
          } else {
              self = .unbekannt
          }
      }
}

struct MenuItem: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let description: String?
}
