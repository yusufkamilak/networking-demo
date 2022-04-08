//
//  HomeViewModel.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

class HomeViewModel: ObservableObject {

    // NOTE: I forgot to retain this service property while dealing with combine and nothing got triggered on sink since I already lost the retainment of subscriptions.
    let service: HomeService
    let strategy: NetworkingStrategy

    init(service: HomeService = HomeService(),
         strategy: NetworkingStrategy = .combine) {
        self.service = service
        self.strategy = strategy
    }

    @Published private(set) var items: [PostItem] = []

    // MARK: - Async / await
    @discardableResult
    func fetchItems() -> [PostItem] {
        service.getPosts(by: strategy) { [weak self] postItems in
            // The point of callback in this function is abstracting the details of strategy from the user so that we can migrate existing functions to async/await still using callback without having to change everywhere. The only difference is that callbacks are getting filled by an async Task instead of traditional way.
            DispatchQueue.main.async {
                self?.items = postItems ?? []
            }
        }
        return self.items
    }
}
