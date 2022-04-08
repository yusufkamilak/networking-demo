//
//  NetworkingManager.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation
import Combine

enum Environment: String {
    case staging, mock
}

protocol NetworkingManagerProtocol: AnyObject {

    var environment: Environment { get }

    /// Traditional way
    func sendRequest<T: Decodable>(for type: T.Type,
                                   endpoint: APIConfiguration,
                                   callback: @escaping (Result<T, Error>) -> Void)
    /// Async/await
    func sendRequest<T: Decodable>(for type: T.Type,
                                   endpoint: APIConfiguration) async -> Result<T, Error>
    /// Combine
    func sendRequest<T: Decodable>(for type: T.Type,
                                   endpoint: APIConfiguration) -> AnyPublisher<T, Error>

}

final class NetworkingManager: NetworkingManagerProtocol {

    // MARK: - Init

    init(environment: Environment) {
        self.environment = environment
    }

    // MARK: - Properties

    private(set) var environment: Environment

    // MARK: - Traditional Method with callbacks

    func sendRequest<T: Decodable>(for type: T.Type = T.self,
                                   endpoint: APIConfiguration,
                                   callback: @escaping (Result<T, Error>) -> Void) {
        guard let request = endpoint.asURLRequest(environment: environment) else {
            callback(.failure(NetworkingError.invalidRequest))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                callback(.failure(error))
            } else if let data = data {
                do {
                    let items = try JSONDecoder().decode(T.self, from: data)
                    callback(.success(items))
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                callback(.failure(NetworkingError.unknownError))
            }
        }.resume()
    }

    // MARK: - Async/await

    func sendRequest<T: Decodable>(for type: T.Type = T.self,
                                   endpoint: APIConfiguration) async -> Result<T, Error> {
        guard let request = endpoint.asURLRequest(environment: environment) else {
            return .failure(NetworkingError.invalidRequest)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            debugPrint(response)
            let postItems = try JSONDecoder().decode(T.self, from: data)
            return .success(postItems)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Combine

    func sendRequest<T: Decodable>(for type: T.Type = T.self,
                                   endpoint: APIConfiguration) -> AnyPublisher<T, Error> {
        guard let request = endpoint.asURLRequest(environment: environment) else {
            // error handling
            fatalError()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ element in
                print("Entered tryMap")
                guard let response = element.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
