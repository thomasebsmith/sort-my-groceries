//
//  ListView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @Binding var list: GroceryList
    @State var showNewItem = false
    @State var editMode = EditMode.inactive
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
                            self.list.items.remove(at: index)
                        }
                    }
                    .onMove { src, dest in
                        self.list.items.move(
                            fromOffsets: self.transform(src, with: byLocation[location]!),
                            toOffset: byLocation[location]![dest].0
                        )
                    }
                }
                .environment(\.editMode, self.$editMode)
            }
        }
        .navigationBarTitle(list.name)
        .navigationBarItems(trailing: HStack {
            EditButton()
            Button(action: {
                self.showNewItem = true
            }, label: {
                Image(systemName: "plus")
            })
        })
        .popover(isPresented: self.$showNewItem) {
            NewItemView(list: self.$list)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var theList = GroceryList(name: "Test", items: [])
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
