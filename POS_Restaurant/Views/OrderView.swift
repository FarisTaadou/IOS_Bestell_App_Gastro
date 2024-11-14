//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct OrderView: View {
    @StateObject private var viewModel = OrderViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $viewModel.filter) {
                    Text("Current").tag(OrderViewModel.OrderFilter.current)
                    Text("Finished").tag(OrderViewModel.OrderFilter.finished)
                    Text("All").tag(OrderViewModel.OrderFilter.all)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(viewModel.filteredOrders) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRow(order: order)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Orders")
            .onAppear {
                viewModel.fetchOrders()
            }
        }
    }
}

struct OrderRow: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tisch \(order.tableNumber)")
                .font(.headline)
            Text("Status: \(order.status)")
                .font(.subheadline)
            Text("Gesamt: €\(order.totalAmount!, specifier: "%.2f")")
                .font(.subheadline)
            Text("Zeit: \(order.orderTime!, formatter: dateFormatter)")
                .font(.subheadline)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
