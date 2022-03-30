//
//  HomeAPIEndpoints.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

enum HomeAPIEndpoints: APIConfiguration {

    // MARK: - Endpoints
    case posts

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .posts:
            return .GET
        }
    }

    /// Endpoint paths after base URL (i.e. /posts)
    var path: String {
        switch self {
        case .posts:
            return "/posts"
        }
    }

    /// Body parameters
    var parameters: [String : Any]? {
        switch self {
        case .posts:
            return nil
        }
    }

    /// Query parameters
    var pathParameters: [String : Any]? {
        switch self {
        case .posts:
            return nil
        }
    }
}
