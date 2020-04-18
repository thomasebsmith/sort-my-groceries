//
//  LocationsSelectorView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/18/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct LocationsSelectorView: View {
    @Binding var list: GroceryList
    @Binding var stores: [GroceryStore]
    var body: some View {
        VStack {
            Text("Stores").bold()
            ForEach(stores.indices, id: \.self) { i in
                LocationSelectorView(list: self.$list, store: self.$stores[i])
            }
        }
    }
}

struct LocationsSelectorView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var list = GroceryList(
        name: "Test list",
        items: [],
        context: context
    )
    @State static var stores = [
        GroceryStore(name: "Test store", context: context)
    ]
    static var previews: some View {
        LocationsSelectorView(list: $list, stores: $stores)
    }
}
