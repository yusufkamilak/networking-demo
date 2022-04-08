//
//  ContentView.swift
//  Shared
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import SwiftUI

struct HomeContentView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Button {

            } label: {
                Text("Combine Screen")
            }

            List(viewModel.items) { item in
                Text(item.title)
            }
        }
        .onAppear {
            // This is quite important because we were able to call an async/await function inside a function that does not support async `onAppear`. Normally, if we wouldn't use Task inside implementation of fetchItems, we would have to call this function inside `.task` instead of here.
            viewModel.fetchItemsWithCombine()
        }
        .refreshable {
            viewModel.fetchItemsWithTraditionalWay()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView(viewModel: HomeViewModel())
    }
}
