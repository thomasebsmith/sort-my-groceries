//
//  GroceryItem.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

struct GroceryItem: Hashable {
    var name: String
    var location: String
    init(name: String, location: String) {
        self.name = name
        self.location = location.localizedCapitalized
    }
}
