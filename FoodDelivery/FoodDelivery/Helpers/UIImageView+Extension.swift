//
//  UIImageView+Extension.swift
//  FoodDelivery
//
//  Created by William on 15/6/24.
//

import UIKit

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {
        ImageCache.shared.countLimit = 100  // Max number of items in cache
        ImageCache.shared.totalCostLimit = 1024 * 1024 * 100  // Max 100 MB
    }
}

extension UIImageView {
    func load(url: URL, placeholder: UIImage? = nil) {
        // Set the placeholder image if any
        self.image = placeholder
        
        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Download the image asynchronously
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to load image from url: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data, scale: 0.0001) else {
                print("Failed to load image from data")
                return
            }
            
            // Cache the image
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString, cost: data.count)
            
            // Set the image on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
