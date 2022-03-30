//
//  BaseService.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

class BaseService {

    init(environment: Environment = .staging) {
        self.networkingManager = NetworkingManager(environment: environment)
    }

    private(set) var networkingManager: NetworkingManager
}
