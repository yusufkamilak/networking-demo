//
//  NetworkingConstants.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

struct APIConstants {

    struct StagingServer {
        static let baseURL = "https://jsonplaceholder.typicode.com"
    }

    struct ParameterKey {
        static let userId = "userId"
        static let id = "id"
        static let title = "title"
        static let body = "body"
    }
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum NetworkingError: Error {
    case invalidRequest
    case badRequest
    case unknownError
}
