//
//  ListOfListsView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct ListOfListsView: View {
    @Environment(\.managedObjectContext) var context
    @State var lists: [GroceryList]
    @State var stores: [GroceryStore]
    @State var config: Config
    @State var showNewMenu = false
    @State var showNewList = false
    @State var showNewStore = false
    var body: some View {
        var newButton: some View {
            Button(action: {
                self.showNewMenu = true
            }, label: {
                Image(systemName: "plus").padding(EdgeInsets(
                    top: 0.0,
                    leading: 10.0,
                    bottom: 0.0,
                    trailing: 0.0
                ))
            })
            .actionSheet(isPresented: self.$showNewMenu) {
                ActionSheet(title: Text("Create New"), message: nil, buttons: [
                    ActionSheet.Button.default(Text("New List")) {
                        self.showNewList = true
                    },
                    ActionSheet.Button.default(Text("New Store")) {
                        self.showNewStore = true
                    },
                    ActionSheet.Button.cancel()
                ])
            }
        }
        return VStack {
            Text("Lists").bold()
            List {
                ForEach(lists.indices, id: \.self) { i in
                    NavigationLink(destination: ListView(
                        list: self.$lists[i],
                        stores: self.$stores,
                        config: self.$config)
                    ) {
                        Text(self.lists[i].name)
                    }
                }
                .onDelete { indices in
                    for i in indices {
                        self.lists.remove(at: i)
                    }
                    do {
                        try self.context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                .onMove { src, dest in
                    // TODO
                    self.lists.move(
                        fromOffsets: src,
                        toOffset: dest
                    )
                }
            }
            .popover(isPresented: self.$showNewList) {
                NewListView(lists: self.$lists).environment(\.managedObjectContext, self.context)
            }
            Text("Stores").bold()
            List {
                ForEach(stores.indices, id: \.self) { i in
                    NavigationLink(destination: StoreView(
                        store: self.$stores[i],
                        config: self.$config
                    )) {
                        Text(self.stores[i].name)
                    }
                }
                .onDelete { indices in
                    for i in indices {
                        self.stores.remove(at: i)
                    }
                    do {
                        try self.context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                .onMove { src, dest in
                    // TODO
                    self.stores.move(
                        fromOffsets: src,
                        toOffset: dest
                    )
                }
            }
            .popover(isPresented: self.$showNewStore) {
                NewStoreView(
                    stores: self.$stores,
                    config: self.$config
                ).environment(\.managedObjectContext, self.context)
            }
        }
        .navigationBarTitle("Sort My Groceries")
        .navigationBarItems(trailing: HStack {
            EditButton()
            newButton
        })
    }
}

struct ListOfListsView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    static var previews: some View {
        ListOfListsView(lists: [
                GroceryList(name: "List 1", items: [], context: context),
                GroceryList(name: "List 2", items: [], context: context)
            ], stores: [
                GroceryStore(name: "Store 1", context: context)
            ], config: Config(context: context)
        )
    }
}
