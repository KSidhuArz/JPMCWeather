//
//  LoadImage.swift
//  WeatherJPMC
//
//  Created by Kulbir Singh on 9/12/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        DispatchQueue.main.async {
            self.image = placeholder
        }
        let cacheKey = url.absoluteString
        // Check if the image is already in the cache
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        // Download the image if it's not in the cache
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else {
                return
            }
            // Cache the image
            ImageCache.shared.setImage(image, forKey: cacheKey)
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}


