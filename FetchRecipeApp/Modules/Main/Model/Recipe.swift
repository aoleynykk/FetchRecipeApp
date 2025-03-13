//
//  Recipe.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let name: String
    let cuisine: String
    let photoUrlSmall: String?
    let photoUrlLarge: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
    }
}
