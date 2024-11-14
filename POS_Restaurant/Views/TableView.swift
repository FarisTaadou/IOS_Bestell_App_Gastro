//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct TableView: View {
    let tables = (1...15).map { Table(id: $0, number: $0, name: "Tisch \($0)", isAvailable: true) }
    @State private var selectedTable: Table?
    
    var body: some View {
        NavigationView {
            GridView(items: tables, columns: 3) { table in
                Button(action: {
                    selectedTable = table
                }) {
                    VStack {
                        Image(systemName: "square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        Text(table.name)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Tables")
            .sheet(item: $selectedTable) { table in
                NavigationView {
                    TakeOrderView(table: table)
                }
            }
        }
    }
}
