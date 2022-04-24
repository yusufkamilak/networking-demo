//
//  HomeServiceMock.swift
//  NetworkingDemoTests
//
//  Created by Yusuf Kamil Ak on 24.04.22.
//

import Foundation
import Combine
@testable import NetworkingDemo

class HomeServiceMock: BaseService, HomeServiceProtocol {

    // Not sure if this must be a part of protocol
    var subscriptions: Set<AnyCancellable> = []

    var getPostsPublishers: [HomeAPIEndpoints : AnyPublisher<[PostItem], Error>] = [:]

    private(set) var countGetPostsByCallback = 0
    private(set) var countGetPostsByAsyncAwait = 0
    private(set) var countGetPostsByCombine = 0
    private(set) var countSubscriptions = 0

    func getPosts(by strategy: NetworkingStrategy, callback: @escaping (([PostItem]?) -> Void)) {
        switch strategy {
        case .callback:
            getPosts(callback: callback)
        case .asyncAwait:
            getPostsByAsyncAwait(callback: callback)
        case .combine:
            getPostsWithCombine(callback: callback)
        }
    }

    private func getPostsByAsyncAwait(callback: @escaping (([PostItem]?) -> Void)) {
        countGetPostsByAsyncAwait += 1
        callback([PostItem(userId: 1, id: 1, title: "test", body: "test")])
    }

    private func getPosts(callback: @escaping (([PostItem]?) -> Void)) {
        countGetPostsByCallback += 1
        callback([PostItem(userId: 1, id: 1, title: "test", body: "test")])
    }

    private func getPostsWithCombine(callback: @escaping ([PostItem]?) -> Void) {
        countSubscriptions += 1
        countGetPostsByCombine += 1
        callback([PostItem(userId: 1, id: 1, title: "test", body: "test")])
    }
}
