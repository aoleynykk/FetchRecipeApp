//
//  HTTPClient.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Combine
import SwiftUI
import Foundation

protocol HTTPClient {
    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

struct InvalidHTTPResponseError: Error { }

extension URLSession: HTTPClient {
    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw InvalidHTTPResponseError()
        }
        return (data, httpResponse)
    }
}

class HTTPClientDecorator: HTTPClient {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            return try await client.perform(request: request)
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
            NotificationCenter.default.post(name: .badInternetConnection, object: nil)
            throw urlError
        } catch {
            throw error
        }
    }
}

struct GenericAPIHTTPRequestMapper {
    static func map<T>(data: Data, response: HTTPURLResponse) throws -> T where T: Decodable {
        if (200..<300) ~= response.statusCode {
            if data.isEmpty {
                throw APIErrorHandler.emptyErrorWithStatusCode(response.statusCode.description)
            } else {
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    let decodingError = error as! DecodingError
                    let detailedError = decodeErrorDetails(error: decodingError, data: data)
                    print("❗️ Decoding Error: \(detailedError)")
                    throw APIErrorHandler.decodingError(detailedError)
                }
            }
        } else {
            if let error = try? JSONDecoder().decode(APIError.self, from: data) {
                throw APIErrorHandler.customApiError(error)
            } else {
                let rawResponse = String(data: data, encoding: .utf8) ?? "No Data"
                        print("❗️ Unexpected Status Code: \(response.statusCode). Raw response: \(rawResponse)")
                throw APIErrorHandler.emptyErrorWithStatusCode("Status code: \(response.statusCode). Response: \(rawResponse)")
            }
        }
    }

    private static func decodeErrorDetails(error: DecodingError, data: Data) -> String {
        var errorMessage = "Decoding error: \(error.localizedDescription)\n"

        switch error {
        case .typeMismatch(let type, let context):
            errorMessage += "Type mismatch for type \(type): \(context.debugDescription)\n"
            errorMessage += "Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))\n"
        case .valueNotFound(let type, let context):
            errorMessage += "Value not found for type \(type): \(context.debugDescription)\n"
            errorMessage += "Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))\n"
        case .keyNotFound(let key, let context):
            errorMessage += "Key not found: \(key.stringValue): \(context.debugDescription)\n"
            errorMessage += "Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))\n"
        case .dataCorrupted(let context):
            errorMessage += "Data corrupted: \(context.debugDescription)\n"
            errorMessage += "Coding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))\n"
        @unknown default:
            errorMessage += "Unknown error: \(error)\n"
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            errorMessage += "JSON Data: \(jsonString)\n"
        }

        return errorMessage
    }
}
