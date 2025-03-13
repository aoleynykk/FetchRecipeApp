//
//  ImageCache.swift
//  FetchRecipeApp
//
//  Created by Alex Oliynyk on 13.03.2025.
//

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func getImage(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }

    func saveImage(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
        saveToDisk(image: image, url: url)
    }

    private func saveToDisk(image: UIImage, url: String) {
        guard let data = image.pngData(),
              let fileURL = getFileURL(for: url) else { return }
        try? data.write(to: fileURL)
    }

    private func getFileURL(for url: String) -> URL? {
        let filename = url.replacingOccurrences(of: "/", with: "_")
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(filename)
    }
}
