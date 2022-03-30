//
//  BaseService.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

enum NetworkingStrategy: String {
    case callback, asyncAwait, combine
}

class BaseService {

    init(environment: Environment = .staging, strategy: NetworkingStrategy = .callback) {
        self.networkingManager = NetworkingManager(environment: environment)
        self.strategy = strategy
    }

    private(set) var networkingManager: NetworkingManager

    private(set) var strategy: NetworkingStrategy
}
