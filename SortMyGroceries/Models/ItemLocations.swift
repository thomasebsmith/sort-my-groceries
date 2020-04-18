//
//  ItemLocations.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/18/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import Foundation

class ItemLocations: NSObject, NSCoding {
    typealias Locations = [GroceryItem: Location]
    var locations: Locations
    override init() {
        self.locations = [:]
    }
    required init?(coder: NSCoder) {
        self.locations = [:]
        if let locs = coder.decodeObject(forKey: "locations") as? Locations {
            self.locations = locs
        }
    }
    func encode(with coder: NSCoder) {
        coder.encode(locations, forKey: "locations")
    }
}

class ItemLocationsTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return ItemLocations.self
    }
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let locs = value as? ItemLocations else {
            return nil
        }
        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: locs,
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
                ofClass: ItemLocations.self,
                from: data
            )
            return list
        }
        catch {
            return nil
        }
    }
}
