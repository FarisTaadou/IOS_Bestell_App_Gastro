//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct MenuItemRow: View {
    let menuItem: MenuItem
    @Binding var selectedOrderItems: [OrderItem]
    @State private var quantity: Int = 0
    @State private var specialRequests: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(menuItem.name)
                    .font(.headline)
                Spacer()
                Text("€\(menuItem.price, specifier: "%.2f")")
            }
            if quantity > 0 {
                HStack {
                    Stepper("Menge: \(quantity)", value: $quantity, in: 1...100, onEditingChanged: { _ in
                        updateOrderItem()
                    })
                    .padding(.vertical, 5)
                }
                TextField("Extra Wünsche", text: $specialRequests, onCommit: {
                    updateOrderItem()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: {
                toggleSelection()
            }) {
                Text(quantity > 0 ? "Enfernen" : "Hinzufügen")
                    .foregroundColor(quantity > 0 ? .red : .blue)
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 5)
    }
    
    //adds/removes items
    private func toggleSelection() {
        if quantity > 0 {
            quantity = 0
            specialRequests = ""
            selectedOrderItems.removeAll { $0.menuItemId == menuItem.id }
        } else {
            quantity = 1
            updateOrderItem()
        }
    }
    
    //checks if OrderItem exists, and updates/ adds a new OrderItem
    private func updateOrderItem() {
        if let index = selectedOrderItems.firstIndex(where: { $0.menuItemId == menuItem.id }) {
            self.selectedOrderItems[index].quantity = quantity
            selectedOrderItems[index].specialRequests = specialRequests
        } else {
            let orderItem = OrderItem(
                menuItemId: menuItem.id,
                quantity: quantity,
                price: menuItem.price,
                specialRequests: specialRequests
            )
            selectedOrderItems.append(orderItem)
        }
    }
}
