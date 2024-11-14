//
//  Table.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import Foundation

struct Table: Identifiable {
    let id: Int
    let number: Int
    let name: String
    var isAvailable: Bool
}
