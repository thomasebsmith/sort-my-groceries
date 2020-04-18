//
//  GroceryItem.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import CoreData
import UIKit

@objc(GroceryItem)
class GroceryItem: NSManagedObject, NSCoding {
    @NSManaged var name: String
    @NSManaged var location: String
    init(name: String, location: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GroceryItem", in: context)!
        super.init(entity: entity, insertInto: context)
        self.name = name
        self.location = location.localizedCapitalized
    }
    required init?(coder: NSCoder) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GroceryItem", in: context)!
        super.init(entity: entity, insertInto: context)
        if let name = coder.decodeObject(forKey: "name") as? String,
           let location = coder.decodeObject(forKey: "location") as? String {
            self.name = name
            self.location = location
        }
    }
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(location, forKey: "location")
    }
}

class GroceryItemTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return GroceryList.self
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let list = value as? GroceryItem else {
            return nil
        }
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: list,
                requiringSecureCoding: true
            )
            return data
        }
        catch {
            return nil
        }
    }
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        do {
            let list = try NSKeyedUnarchiver.unarchivedObject(
                ofClass: GroceryItem.self,
                from: data
            )
            return list
        }
        catch {
            return nil
        }
    }
}
