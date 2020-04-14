//
//  NewItemView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct NewItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var list: GroceryList
    @State var itemName = ""
    @State var itemLocation = ""
    func getNewItem() -> GroceryItem {
        return GroceryItem(name: itemName, location: itemLocation)
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
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Add").bold() })
            }
            TextField("Name", text: self.$itemName).padding()
            TextField("Location", text: self.$itemLocation).padding()
            Spacer()
        }.padding()
    }
}

struct NewItemView_Previews: PreviewProvider {
    @State static var list = GroceryList(name: "Test list", items: [])
    static var previews: some View {
        NewItemView(list: $list)
    }
}
