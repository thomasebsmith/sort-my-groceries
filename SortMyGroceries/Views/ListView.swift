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
    @State var showNewItem = false
    lazy var editList = GroceryList(name: "", items: [], context: context)
    func transform(_ indices: IndexSet, with: [(Int, GroceryItem)]) -> IndexSet {
        var result = IndexSet()
        indices.forEach { index in result.insert(with[index].0) }
        return result
    }
    var body: some View {
        let byLocation = list.sortedByLocation()
        return ForEach(byLocation.keys.sorted(), id: \.self) { location in
            Section(header: Text(location).bold()) {
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
            NewItemView(list: self.$list).environment(\.managedObjectContext, self.context)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    static var theList = GroceryList(name: "Test", items: [], context: context)
    static var binding = Binding<GroceryList>(
        get: { theList },
        set: { newList in
            theList = newList
        }
    )
    static var previews: some View {
        ListView(list: binding)
    }
}
