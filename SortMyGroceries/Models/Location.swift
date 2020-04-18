//
//  Location.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/18/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import Foundation

struct Location: Comparable, Hashable {
    var text: String
    init(_ text: String) {
        self.text = text.localizedCapitalized
    }
    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.text < rhs.text
    }
}
