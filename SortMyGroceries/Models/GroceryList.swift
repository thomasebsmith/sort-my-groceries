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
    @NSManaged var name: String
    @NSManaged var items: [GroceryItem]
    init(name: String, items: [GroceryItem], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GroceryList", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.items = items
    }
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    func sortedByLocation(locations: ItemLocations) -> [Location: [(Int, GroceryItem)]] {
        var sorted: [Location: [(Int, GroceryItem)]] = [:]
        for (i, item) in items.enumerated() {
            if sorted[item.locationIn(locations)] == nil {
                sorted[item.locationIn(locations)] = []
            }
            sorted[item.locationIn(locations)]?.append((i, item))
        }
        return sorted
    }
    static func fetchAll() -> NSFetchRequest<GroceryList> {
        let request = GroceryList.fetchRequest() as! NSFetchRequest<GroceryList>
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
}
