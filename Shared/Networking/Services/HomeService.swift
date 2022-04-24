//
//  HomeService.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation
import Combine

protocol HomeServiceProtocol: AnyObject {
    var subscriptions: Set<AnyCancellable> { set get }
    var getPostsPublishers: [HomeAPIEndpoints: AnyPublisher<[PostItem], Error>] { set get }

    func getPosts(by strategy: NetworkingStrategy, callback: @escaping (([PostItem]?) -> Void))
}

class HomeService: BaseService, HomeServiceProtocol {

    // MARK: - Properties

    /// We need to retain subscriptions as long as we need them. To ensure preventing a retain cycle, they need to be defined as Cancellable so that they will be deleted automatically when they are no longer used or deinit is called.
    var subscriptions = Set<AnyCancellable>()

    var getPostsPublishers: [HomeAPIEndpoints: AnyPublisher<[PostItem], Error>] = [:]

    func getPosts(by strategy: NetworkingStrategy, callback: @escaping (([PostItem]?) -> Void)) {
        switch strategy {
        case .callback:
            getPosts(callback: callback)
        case .asyncAwait:
            // We break the async chain by using Task here so that we don't have to make `getPosts` async as well.
            Task {
                let posts = await getPosts()
                callback(posts)
            }
        case .combine:
            getPostsWithCombine(callback: callback)
        }
    }

    // MARK: - async await

    private func getPosts() async -> [PostItem]? {
        let endpoint = HomeAPIEndpoints.posts

        let result = await networkingManager
            .sendRequest(for: [PostItem].self, endpoint: endpoint)

        switch result {
        case .success(let postItems):
            return postItems
        case .failure(let error):
            debugPrint(error)
            return nil
        }
    }

    // MARK: - traditional way for making an asynchronous call and getting response from callback
    private func getPosts(callback: @escaping (([PostItem]?) -> Void)) {
        let endpoint = HomeAPIEndpoints.posts

        networkingManager.sendRequest(for: [PostItem].self,
                                      endpoint: endpoint) { result in
            switch result {
            case .failure(let error):
                print(error)
                callback(nil)
            case .success(let postItems):
                callback(postItems)
            }
        }
    }

    // MARK: - Combine
    private func getPosts() -> AnyPublisher<[PostItem], Error> {
        let endpoint = HomeAPIEndpoints.posts
        if let getPostsPublisher = getPostsPublishers[endpoint] {
            return getPostsPublisher
        }

        let publisher = networkingManager
            .sendRequest(for: [PostItem].self, endpoint: endpoint)
        getPostsPublishers[endpoint] = publisher
        return publisher
    }

    private func getPostsWithCombine(callback: @escaping ([PostItem]?) -> Void) {
        getPosts()
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    debugPrint(error)
                    callback(nil)
                case .finished:
                    print("Entered finished case")
                    break
                }
            }, receiveValue: { (postItems) in
                // Normally using callback with Combine is a bit unusual and against its purpose of usage. But since we want to create an abstraction between network layer and client about used strategy, we decided to stick with callbacks and use them in all networking strategies to provide a single output for all methods.
                print("Entered receiveValue")
                callback(postItems)
            })
        .store(in: &subscriptions)

    }
}
