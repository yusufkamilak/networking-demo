//
//  HomeViewModel.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

class HomeViewModel: ObservableObject {

    init() {
        items = []
    }

    @Published private(set) var items: [PostItem]

    func fetchItems() {
        HomeService().getPosts { [weak self] postItems in
            if let postItems = postItems {
                DispatchQueue.main.async {
                    self?.items = postItems
                }
            } else {
                // Show some errors and placeholder view.
            }
        }
    }
}
