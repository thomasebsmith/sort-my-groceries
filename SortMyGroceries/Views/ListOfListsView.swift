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
    @State var showNewList = false
    var body: some View {
        List {
            ForEach(lists.indices, id: \.self) { i in
                NavigationLink(destination: ListView(list: self.$lists[i])) {
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
        .navigationBarTitle("Lists")
        .navigationBarItems(trailing: HStack {
            EditButton()
            Button(action: {
                self.showNewList = true
            }, label: {
                Image(systemName: "plus").padding(EdgeInsets(
                    top: 0.0,
                    leading: 10.0,
                    bottom: 0.0,
                    trailing: 0.0
                ))
            })
        })
        .popover(isPresented: self.$showNewList) {
            NewListView(lists: self.$lists).environment(\.managedObjectContext, self.context)
        }
    }
}

struct ListOfListsView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    static var previews: some View {
        ListOfListsView(lists: [
            GroceryList(name: "List 1", items: [], context: context),
            GroceryList(name: "List 2", items: [], context: context)
        ])
    }
}
