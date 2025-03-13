//
//  RecipeProvider.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Foundation

enum RecipeProvider {
    case getRecipes
    case getMalformedRecipes
    case getEmptyData
}

extension RecipeProvider: ApiEndpoint {
    var baseURLString: String {
        return APIConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .getRecipes:
            return "recipes.json"
        case .getMalformedRecipes:
            return "recipes-malformed.json"
        case .getEmptyData:
            return "recipes-empty.json"
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var method: APIHTTPMethod {
        return .GET
    }
}
