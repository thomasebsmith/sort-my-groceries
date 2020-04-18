//
//  GroceryItem.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import CoreData

@objc(GroceryItem)
class GroceryItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var location: String
    init(name: String, location: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GroceryItem", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.location = location.localizedCapitalized
    }
}
