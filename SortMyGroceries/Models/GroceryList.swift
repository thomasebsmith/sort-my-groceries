//
//  GroceryList.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import CoreData

@objc(GroceryList)
class GroceryList: NSManagedObject {
    typealias Location = String
    @NSManaged var name: String
    @NSManaged var items: [GroceryItem]
    init(name: String, items: [GroceryItem], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GroceryList", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.items = items
    }
    func sortedByLocation() -> [Location: [(Int, GroceryItem)]] {
        var sorted: [Location: [(Int, GroceryItem)]] = [:]
        for (i, item) in items.enumerated() {
            if sorted[item.location] == nil {
                sorted[item.location] = []
            }
            sorted[item.location]?.append((i, item))
        }
        return sorted
    }
    var locations: Set<Location> {
        return Set(items.map { $0.location })
    }
    func autocomplete(location: Location) -> Location? {
        let location = location.localizedCapitalized
        var possibleMatches: [Location: Int] = [:]
        for item in items {
            if item.location.starts(with: location) {
                if possibleMatches[item.location] == nil {
                    possibleMatches[item.location] = 0
                }
                possibleMatches[item.location]! += 1
            }
        }
        return possibleMatches.max(by: <)?.key
    }
}
