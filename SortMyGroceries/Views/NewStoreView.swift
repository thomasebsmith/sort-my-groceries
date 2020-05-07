//
//  NewStoreView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/17/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct NewStoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @Binding var stores: [GroceryStore]
    @Binding var config: Config
    @State var storeName = ""
    func getNewStore() -> GroceryStore {
        return GroceryStore(name: storeName, context: context)
    }
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Cancel") })
                Spacer()
                Text("New Store").bold()
                Spacer()
                Button(action: {
                    if self.config.store(for: self.stores) == nil {
                        self.config.setCurrentStore(0)
                    }
                    self.stores.append(self.getNewStore())
                    do {
                        try self.context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Add").bold() })
            }
            TextField("Name", text: self.$storeName).padding()
            Spacer()
        }.padding()
    }
}

struct NewStoreView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    @State static var stores: [GroceryStore] = []
    @State static var config = Config(context: context)
    static var previews: some View {
        NewStoreView(stores: $stores, config: $config)
    }
}
