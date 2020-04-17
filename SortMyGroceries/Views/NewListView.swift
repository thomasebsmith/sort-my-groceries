//
//  NewListView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/17/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct NewListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var lists: [GroceryList]
    @State var listName = ""
    func getNewList() -> GroceryList {
        return GroceryList(name: listName, items: [])
    }
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Cancel") })
                Spacer()
                Button(action: {
                    self.lists.append(self.getNewList())
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Add").bold() })
            }
            TextField("Name", text: self.$listName).padding()
            Spacer()
        }.padding()
    }
}

struct NewListView_Previews: PreviewProvider {
    @State static var lists: [GroceryList] = []
    static var previews: some View {
        NewListView(lists: $lists)
    }
}
