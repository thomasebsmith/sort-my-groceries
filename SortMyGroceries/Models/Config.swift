//
//  Config.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/18/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import CoreData
import UIKit

@objc(Config)
class Config: NSManagedObject {
    @NSManaged private var currentStore: Int64
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: "Config",
            in: context
        )!
        super.init(entity: entity, insertInto: context)
        self.currentStore = 0
    }
    override init(entity: NSEntityDescription,
                  insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    func store(for stores: [GroceryStore]) -> GroceryStore? {
        if currentStore >= 0 && currentStore < stores.count {
            return stores[Int(currentStore)]
        }
        return nil
    }
    func setCurrentStore(_ index: Int) {
        currentStore = Int64(index)
    }
    static func fetchAll() -> NSFetchRequest<Config> {
        let request = Config.fetchRequest() as! NSFetchRequest<Config>
        request.sortDescriptors = [
            NSSortDescriptor(key: "currentStore", ascending: true)
        ]
        return request
    }
}
