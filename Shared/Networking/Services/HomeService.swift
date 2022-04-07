//
//  HomeService.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

class HomeService: BaseService {

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
            break
        }
    }

    /// async await
    func getPosts() async -> [PostItem]? {
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

    /// traditional way for making an asynchronous call and getting response from callback
    func getPosts(callback: @escaping (([PostItem]?) -> Void)) {
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
}
