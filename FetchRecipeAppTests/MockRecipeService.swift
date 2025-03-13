//
//  MockRecipeService.swift
//  FetchRecipeAppTests
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Foundation
@testable import FetchRecipeApp

class MockRecipeService: RecipeService {
    var fetchSuccess = true
    var returnEmptyRecipes = false

    override func getRecipes() async throws -> RecipeResponseModel {
        if fetchSuccess {
            return returnEmptyRecipes ?
            RecipeResponseModel(recipes: []) :
            RecipeResponseModel(recipes: [
                Recipe(id: "1", name: "Recipe 1", cuisine: "Cuisine 1", photoUrlSmall: nil, photoUrlLarge: nil),
                Recipe(id: "2", name: "Recipe 2", cuisine: "Cuisine 2", photoUrlSmall: nil, photoUrlLarge: nil),
                Recipe(id: "3", name: "Recipe 3", cuisine: "Cuisine 3", photoUrlSmall: nil, photoUrlLarge: nil)
            ])
        } else {
            throw APIErrorHandler.customApiError(APIError(statusCode: 1, message: "Error Message", error: "Error", errors: nil))
        }
    }
}
