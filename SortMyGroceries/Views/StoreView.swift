//
//  StoreView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 5/7/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct StoreView: View {
    @Binding var store: GroceryStore
    @Binding var config: Config
    var body: some View {
        List {
            ForEach(store.itemLocations.locations.values.sorted(), id: \.self) { location in
                Text(location.text)
            }
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var store = GroceryStore(name: "My Store", context: context)
    @State static var config = Config(context: context)
    static var previews: some View {
        StoreView(store: $store, config: $config)
    }
}
