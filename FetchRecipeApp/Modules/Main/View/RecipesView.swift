//
//  RecipesView.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel = RecipeViewModel(
        service: RecipeService(httpClient: HTTPClientDecorator(client: URLSession.shared))
    )

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                } else if viewModel.recipes.isEmpty {
                    Text("No recipes available")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.recipes) { recipe in
                        RecipeCell(recipe: recipe)
                    }
                }
            }
            .navigationTitle("Recipes")
            .refreshable {
                await viewModel.fetchRecipes()
            }
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}
