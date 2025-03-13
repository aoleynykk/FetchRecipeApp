//
//  APIError.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Foundation

enum ErrorValue: Codable {
    case string(String)
    case array([String])
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            self = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .unknown:
            break
        }
    }
}

struct APIError: Codable {
    let statusCode: Int?
    let message: String?
    let error: String?
    let errors: [String: ErrorValue]?

    enum CodingKeys: String, CodingKey {
        case statusCode
        case message
        case error
        case errors
    }
}

enum APIErrorHandler: Error {
    case customApiError(APIError)
    case requestFailed
    case normalError(Error)
    case emptyErrorWithStatusCode(String)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .customApiError(let apiError):
            var errorItems = [String]()

            if let errorMessage = apiError.message {
                errorItems.append(errorMessage)
            }

            if let error = apiError.error {
                errorItems.append(error)
            }

            if let errorItemsDTO = apiError.errors {
                for (_, value) in errorItemsDTO {
                    switch value {
                    case .string(let stringValue):
                        errorItems.append(stringValue)
                    case .array(let arrayValue):
                        errorItems.append(contentsOf: arrayValue)
                    case .unknown:
                        errorItems.append("Unknown error")
                    }
                }
            }

            if errorItems.isEmpty {
                errorItems.append("Internal error!")
            }

            return errorItems.joined(separator: "\n")

        case .requestFailed:
            return "Request failed"
        case .normalError(let error):
            return error.localizedDescription
        case .emptyErrorWithStatusCode(let status):
            return status
        case .decodingError(let errorString):
            return errorString
        }
    }

    var statusCode: Int {
        switch self {
        case .customApiError(let apiError):
            return apiError.statusCode ?? 0
        default:
            return 0
        }
    }
}
