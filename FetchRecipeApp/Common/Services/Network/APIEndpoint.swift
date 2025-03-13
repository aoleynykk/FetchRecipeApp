//
//  APIEndpoint.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Foundation

enum APIHTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

protocol ApiEndpoint {
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var method: APIHTTPMethod { get }
}

extension ApiEndpoint {
    var makeRequest: URLRequest {
        var urlComponents = URLComponents(string: baseURLString)
        var longPath = ""

        if !path.isEmpty {
            longPath.append("/")
            longPath.append(path)
        }

        urlComponents?.path = longPath

        guard let url = urlComponents?.url else { return URLRequest(url: URL(string: baseURLString)!) }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        return request
    }
}
