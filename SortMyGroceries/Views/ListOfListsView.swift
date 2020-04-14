//
//  ListOfListsView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct ListOfListsView: View {
    @State var lists: [GroceryList]
    var body: some View {
        List(lists.indices, id: \.self) { i in
            NavigationLink(destination: ListView(list: self.$lists[i])) {
                Text(self.lists[i].name)
            }
        }
        .navigationBarTitle("Lists")
    }
}

struct ListOfListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfListsView(lists: [
            GroceryList(name: "List 1", items: []),
            GroceryList(name: "List 2", items: [])
        ])
    }
}
