//
//  NetworkingManagerMock.swift
//  NetworkingDemoTests
//
//  Created by Yusuf Kamil Ak on 24.04.22.
//

import Foundation
import Combine
@testable import NetworkingDemo

class NetworkingManagerMock: NetworkingManagerProtocol {

    // TODO: Ask how to use this networkingmanagermock or do we really need this?

    var environment: Environment = .mock

    func sendRequest<T>(for type: T.Type, endpoint: APIConfiguration, callback: @escaping (Result<T, Error>) -> Void) where T : Decodable {

    }

    func sendRequest<T>(for type: T.Type, endpoint: APIConfiguration) async -> Result<T?, Error> where T : Decodable {
        return .success(nil)
    }

    func sendRequest<T>(for type: T.Type, endpoint: APIConfiguration) -> AnyPublisher<T, Error> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: URL(string: "")!)
            .tryMap({ element in
                return element.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
