//
//  MenuItem.swift
//  POS_Restaurant
//
//  Created by Faris on 12.11.24.
//

import SwiftUI

struct GridView<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let columns: Int
    let content: (Item) -> Content
    
    var body: some View {
        ScrollView {
            let rows = items.chunked(into: columns)
            VStack {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack {
                        ForEach(rows[rowIndex]) { item in
                            content(item)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
