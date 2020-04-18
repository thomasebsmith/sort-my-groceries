//
//  ContentView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(fetchRequest: GroceryList.fetchAll()) var lists: FetchedResults<GroceryList>
    @FetchRequest(fetchRequest: GroceryStore.fetchAll()) var stores: FetchedResults<GroceryStore>
    @FetchRequest(fetchRequest: Config.fetchAll()) var configs: FetchedResults<Config>
    func newConfig() -> Config {
        let config = Config(context: context)
        do {
            try context.save()
        } catch {
            fatalError("Failed to save context: \(error)")
        }
        return config
    }
    var body: some View {
        NavigationView {
            ListOfListsView(
                lists: lists.sorted { $0.name < $1.name },
                stores: stores.sorted { $0.name < $1.name },
                config: configs.first ?? newConfig()
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
