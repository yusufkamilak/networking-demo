//
//  APIConfiguration.swift
//  NetworkingDemo
//
//  Created by Yusuf Kamil Ak on 30.03.22.
//

import Foundation

protocol APIConfiguration {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String : Any]? { get }
    var pathParameters: [String: Any]? { get }
    func asURLRequest(environment: Environment) -> URLRequest?
}

extension APIConfiguration {

    func asURLRequest(environment: Environment = .staging) -> URLRequest? {
        let baseURL = environment == .staging ? APIConstants.StagingServer.baseURL : APIConstants.MockServer.baseURL
        guard var components = URLComponents(string: baseURL + path) else {
            return nil
        }

        if let pathParameters = pathParameters {
            for param in pathParameters {
                if components.queryItems == nil {
                    components.queryItems = []
                }
                components.queryItems?.append(URLQueryItem(name: param.key, value: param.value as? String))
            }
        }

        guard let fullUrl = components.url else { return nil }
        var urlRequest = URLRequest(url: fullUrl)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue,
                            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        // Parameters
        if let parameters = parameters {
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        return urlRequest
    }
}
