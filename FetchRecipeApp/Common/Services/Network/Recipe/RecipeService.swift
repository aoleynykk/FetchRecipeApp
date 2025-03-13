//
//  RecipeService.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Foundation
import Combine

class RecipeService {

    private let httpClient: HTTPClientDecorator

    init(httpClient: HTTPClientDecorator) {
        self.httpClient = httpClient
    }

    func getRecipes() async throws -> RecipeResponseModel {
        let request = RecipeProvider.getRecipes.makeRequest
        let (data, response) = try await httpClient.perform(request: request)
        return try GenericAPIHTTPRequestMapper.map(data: data, response: response)
    }

    func getMalformedRecipes() async throws -> RecipeResponseModel {
        let request = RecipeProvider.getMalformedRecipes.makeRequest
        let (data, response) = try await httpClient.perform(request: request)
        return try GenericAPIHTTPRequestMapper.map(data: data, response: response)
    }

    func getEmptyRecipes() async throws -> RecipeResponseModel {
        let request = RecipeProvider.getEmptyData.makeRequest
        let (data, response) = try await httpClient.perform(request: request)
        return try GenericAPIHTTPRequestMapper.map(data: data, response: response)
    }
}
