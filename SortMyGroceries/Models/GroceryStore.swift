//
//  GroceryStore.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/18/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import CoreData

@objc(GroceryStore)
class GroceryStore: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var itemLocations: ItemLocations
    var locations: Set<Location> {
        return Set(itemLocations.locations.values)
    }
    init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GroceryStore", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.itemLocations = ItemLocations()
    }
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    static func fetchAll() -> NSFetchRequest<GroceryStore> {
        let request = GroceryStore.fetchRequest() as! NSFetchRequest<GroceryStore>
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
}
