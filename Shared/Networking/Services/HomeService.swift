//
//  HomeService.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

class HomeService: BaseService {

    /// traditional way for making an asynchronous call and getting response from callback
    func getPosts(callback: @escaping ([PostItem]?) -> Void) {
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