//
//  RecipeCell.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe

    @State var image: UIImage?

    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ProgressView()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .task {
                        await loadImage()
                    }
            }

            VStack(alignment: .leading) {
                Text(recipe.name ?? "Empty Name")
                    .font(.headline)
                    .lineLimit(1)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }

    func loadImage() async {
        guard let urlString = recipe.photoUrlSmall, let url = URL(string: urlString) else { return }

        if let cachedImage = ImageCache.shared.getImage(for: urlString) {
            image = cachedImage
        } else {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let downloadedImage = UIImage(data: data) {
                    ImageCache.shared.saveImage(downloadedImage, for: urlString)
                    image = downloadedImage
                }
            } catch {
                image = UIImage(systemName: "photo")
                print("Failed to load image: \(error)")
            }
        }
    }
}
