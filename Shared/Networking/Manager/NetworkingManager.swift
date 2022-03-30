//
//  NetworkingManager.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

enum Environment: String {
    case staging, mock
}

final class NetworkingManager {

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
        guard let request = endpoint.asURLRequest() else {
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

    

    // MARK: - Combine

}
