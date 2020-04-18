//
//  LocationSelectorView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/18/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct LocationSelectorView: View {
    @Binding var list: GroceryList
    @Binding var store: GroceryStore
    @State var selectedLocation: Int = 0
    @State var typedLocation = ""
    var otherSelected: Bool {
        return selectedLocation == store.locations.count
    }
    init(list: Binding<GroceryList>, store: Binding<GroceryStore>) {
        self._list = list
        self._store = store
        self._selectedLocation = State(initialValue: self.store.locations.count)
    }
    var body: some View {
        VStack {
            Picker(selection: self.$selectedLocation, label: Text("Location")) {
                ForEach(self.store.locations.sorted().indices, id: \.self) { i in
                    Text(self.store.locations.sorted()[i].text).tag(i)
                }
                Text("Other...").tag(self.store.locations.count)
            }.labelsHidden()
            if otherSelected {
                TextField("Other location", text: self.$typedLocation).padding()
            }
        }
    }
}

struct LocationSelectorView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var list = GroceryList(name: "List 1", items: [], context: context)
    @State static var store = GroceryStore(name: "Store 1", context: context)
    static var previews: some View {
        LocationSelectorView(list: $list, store: $store)
    }
}
