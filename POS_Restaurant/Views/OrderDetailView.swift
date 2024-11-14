//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct OrderDetailView: View {
    let order: Order

    // DateFormatter definieren
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // z.B. "Nov 12, 2023"
        formatter.timeStyle = .short  // z.B. "2:30 PM"
        return formatter
    }()

    var body: some View {
        List {
            Section(header: Text("Bestelldetails")) {
                Text("Tisch Nr.: \(order.tableNumber)")
                Text("Status: \(order.status ?? "Unknown")")
                if let totalAmount = order.totalAmount {
                    Text("GesamtBetrag: €\(totalAmount, specifier: "%.2f")")
                }
                if let orderTime = order.orderTime {
                    Text("Order Time: \(orderTime, formatter: dateFormatter)")
                }
                if let notes = order.notes, !notes.isEmpty {
                    Text("Notes: \(notes)")
                }
            }

            Section(header: Text("Bestellungen")) {
                ForEach(order.orderItems) { item in
                    VStack(alignment: .leading) {
                        Text("ID: \(item.menuItemId)")
                        Text("Menge: \(item.quantity)")
                        Text("Preis: €\(item.price, specifier: "%.2f")")
                        if let specialRequests = item.specialRequests, !specialRequests.isEmpty {
                            Text("Extra Wünsche: \(specialRequests)")
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Bestellung \(order.id ?? 0)")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
