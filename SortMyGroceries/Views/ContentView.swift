//
//  ContentView.swift
//  SortMyGroceries
//
//  Created by Thomas Smith on 4/13/20.
//  Copyright © 2020 Thomas Smith. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(fetchRequest: GroceryList.fetchAll()) var lists: FetchedResults<GroceryList>
    var body: some View {
        NavigationView {
            ListOfListsView(lists: lists.sorted { $0.name < $1.name })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
