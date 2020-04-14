//
//  GroceryList.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import Foundation

struct GroceryList: Hashable {
    var name: String
    var items: [GroceryItem]
    func sortedByLocation() -> [String: [(Int, GroceryItem)]] {
        var sorted: [String: [(Int, GroceryItem)]] = [:]
        for (i, item) in items.enumerated() {
            if sorted[item.location] == nil {
                sorted[item.location] = []
            }
            sorted[item.location]?.append((i, item))
        }
        return sorted
    }
}
