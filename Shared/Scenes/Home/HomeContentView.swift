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
            List(viewModel.items) { item in
                Text(item.title)
            }
        }
        .task {
            await viewModel.fetchItems()
        }
        .refreshable {
            await viewModel.fetchItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView(viewModel: HomeViewModel())
    }
}
