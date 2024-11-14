//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import Foundation

class TableViewModel: ObservableObject {
    @Published var tables: [Table] = []
    
    //TODO: Später Dynamisch initialisieren
    init() {
        tables = (1...15).map {Table(id: $0, number:1, name: "Tisch \($0)", isAvailable: true)}
    }
    
    func startOrder (for table: Table){
        print ("Bestellung für \(table.name) gestartet")
        
        if let index = tables.firstIndex(where: { $0.id == table.id}){
            tables[index].isAvailable = false
        }
    }
}
