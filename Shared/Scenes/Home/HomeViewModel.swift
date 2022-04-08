//
//  HomeViewModel.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

class HomeViewModel: ObservableObject {

    // NOTE: I forgot to retain this service property while dealing with combine and nothing got triggered on sink since I already lost the retainment of subscriptions.
    var service = HomeService()

    init() {
        items = []
    }

    @Published private(set) var items: [PostItem]

    // MARK: - Async / await
    @discardableResult
    func fetchItemsWithAsyncAwaitStrategy() -> [PostItem] {
        service.getPosts(by: .asyncAwait) { [weak self] postItems in
            // The point of callback in this function is abstracting the details of strategy from the user so that we can migrate existing functions to async/await still using callback without having to change everywhere. The only difference is that callbacks are getting filled by an async Task instead of traditional way.
            DispatchQueue.main.async {
                self?.items = postItems ?? []
            }
        }
        return self.items
    }

    // MARK: - Traditional way. (Duplicating method just to demonstrate only difference is the parameter.)
    @discardableResult
    func fetchItemsWithTraditionalWay() -> [PostItem] {
        service.getPosts(by: .callback) { [weak self] postItems in
            // The point of callback in this function is abstracting the details of strategy from the user so that we can migrate existing functions to async/await still using callback without having to change everywhere. The only difference is that callbacks are getting filled by an async Task instead of traditional way.
            DispatchQueue.main.async {
                self?.items = postItems ?? []
            }
        }
        return self.items
    }

    // MARK: - Traditional way. (Duplicating method just to demonstrate only difference is the parameter.)
    @discardableResult
    func fetchItemsWithCombine() -> [PostItem] {
        service.getPosts(by: .combine) { [weak self] postItems in
            // The point of callback in this function is abstracting the details of strategy from the user so that we can migrate existing functions to async/await still using callback without having to change everywhere. The only difference is that callbacks are getting filled by combine publishers instead of traditional way.
            DispatchQueue.main.async {
                self?.items = postItems ?? []
            }
        }
        return self.items
    }
}
