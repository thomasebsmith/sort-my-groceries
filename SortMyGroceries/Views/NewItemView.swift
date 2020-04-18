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
    @State var itemName = ""
    @State var selectedLocation: Int = 0
    @State var typedLocation = ""
    init(list: Binding<GroceryList>) {
        self._list = list
        self._selectedLocation = State(initialValue: self.list.locations.count)
    }
    var otherSelected: Bool {
        return selectedLocation == list.locations.count
    }
    func getNewItem() -> GroceryItem {
        if otherSelected {
            return GroceryItem(name: itemName, location: typedLocation, context: context)
        }
        return GroceryItem(name: itemName,
                           location: list.locations.sorted()[selectedLocation],
                           context: context)
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
                    do {
                        try self.context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Add").bold() })
            }
            TextField("Name", text: self.$itemName).padding()
            Picker(selection: self.$selectedLocation, label: Text("Location")) {
                ForEach(self.list.locations.sorted().indices, id: \.self) { i in
                    Text(self.list.locations.sorted()[i]).tag(i)
                }
                Text("Other...").tag(self.list.locations.count)
            }.labelsHidden()
            if otherSelected {
                TextField("Other location", text: self.$typedLocation).padding()
            }
            Spacer()
        }.padding()
    }
}

struct NewItemView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var list = GroceryList(name: "Test list", items: [], context: context)
    static var previews: some View {
        NewItemView(list: $list)
    }
}
