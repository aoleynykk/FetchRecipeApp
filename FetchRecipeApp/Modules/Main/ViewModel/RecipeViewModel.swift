//
//  RecipeViewModel.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import SwiftUI

//@MainActor
class RecipeViewModel: ObservableObject {

    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String?

    var service: RecipeService

    init(service: RecipeService) {
        self.service = service
    }

    func fetchRecipes() async {
        do {
            let fetchedRecipes = try await service.getRecipes()
            DispatchQueue.main.async {
                self.recipes = fetchedRecipes.recipes
            }
        } catch let error {
            if let apiError = error as? APIErrorHandler {
                DispatchQueue.main.async {
                    self.errorMessage = apiError.errorDescription
                }
            }
        }
    }
}
