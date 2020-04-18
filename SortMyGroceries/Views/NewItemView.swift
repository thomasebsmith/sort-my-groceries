//
//  NewItemView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct NewItemView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @Binding var list: GroceryList
    @Binding var stores: [GroceryStore]
    @State var itemName = ""
    func getNewItem() -> GroceryItem {
        return GroceryItem(name: itemName, context: context)
    }
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Cancel") })
                Spacer()
                Button(action: {
                    self.list.items.append(self.getNewItem())
                    // TODO/FIXME: update locations
                    do {
                        try self.context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Add").bold() })
            }
            TextField("Name", text: self.$itemName).padding()
            LocationsSelectorView(list: self.$list, stores: self.$stores)
            Spacer()
        }.padding()
    }
}

struct NewItemView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var list = GroceryList(name: "Test list", items: [], context: context)
    @State static var stores = [GroceryStore(name: "Test store", context: context)]
    static var previews: some View {
        NewItemView(list: $list, stores: $stores)
    }
}
