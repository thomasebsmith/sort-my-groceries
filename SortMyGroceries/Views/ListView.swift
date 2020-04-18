//
//  ListView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var context
    @Binding var list: GroceryList
    @Binding var stores: [GroceryStore]
    @Binding var config: Config
    @State var showNewItem = false
    lazy var editList = GroceryList(name: "", items: [], context: context)
    func transform(_ indices: IndexSet, with: [(Int, GroceryItem)]) -> IndexSet {
        var result = IndexSet()
        indices.forEach { index in result.insert(with[index].0) }
        return result
    }
    var body: some View {
        let locations = config.store(for: stores)?.itemLocations ?? ItemLocations()
        let byLocation = list.sortedByLocation(locations: locations)
        return ForEach(byLocation.keys.sorted(), id: \.self) { location in
            Section(header: Text(location.text).bold()) {
                List {
                    ForEach(byLocation[location]!.map { pair in pair.1 },
                             id: \.self) { item in
                        Text(item.name)
                    }
                    .onDelete { indices in
                        self.transform(indices, with: byLocation[location]!).forEach { index in
                            if index < self.list.items.count {
                                self.list.items.remove(at: index)
                            }
                        }
                        do {
                            try self.context.save()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                    .onMove { src, dest in
                        if let category = byLocation[location],
                               dest < category.count {
                            self.list.items.move(
                                fromOffsets: self.transform(src, with: category),
                                toOffset: category[dest].0
                            )
                        }
                        do {
                            try self.context.save()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                }
            }
        }
        .navigationBarTitle(list.name)
        .navigationBarItems(trailing: HStack {
            EditButton()
            Button(action: {
                self.showNewItem = true
            }, label: {
                Image(systemName: "plus").padding(EdgeInsets(
                    top: 0.0,
                    leading: 10.0,
                    bottom: 0.0,
                    trailing: 0.0
                ))
            })
        })
        .popover(isPresented: self.$showNewItem) {
            NewItemView(list: self.$list, stores: self.$stores)
                .environment(\.managedObjectContext, self.context)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var theList = GroceryList(name: "Test", items: [], context: context)
    @State static var stores = [
        GroceryStore(name: "Test Store", context: context)
    ]
    @State static var config = Config(context: context)
    static var previews: some View {
        ListView(list: $theList, stores: $stores, config: $config)
    }
}
