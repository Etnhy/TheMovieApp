//
//  ImageCache.swift
//  TheMovieApp
//
//  Created by evhn on 17.12.2024.
//


import UIKit
import DataCache
import Foundation

protocol ImageCacheProtocol {
    func saveImage(imageId: String,image: UIImage)
    func getImage(imageId: String,for size: ImageSizeType) -> UIImage?
    func clearCache(id: String)
}

enum ImageSizeType: String, CaseIterable {
    case small
    case medium
    case large
}

final class ImageCache: ImageCacheProtocol {
    
    private let cache = DataCache.instance
    
    func saveImage(imageId: String,image: UIImage) {
        if !cache.hasData(forKey: imageId) {
            cache.write(image: image, forKey: imageId)
        }
    }
    
    func getImage(imageId: String,for size: ImageSizeType) -> UIImage? {
        let originallImage = cache.readImage(forKey: imageId)
        switch size {
        case .small:
            return originallImage?.resized(by: 0.1)
        case .medium:
            return originallImage?.resized(by: 0.5)

        case .large:
            return originallImage
            
        }

    }
    
    func clearCache(id: String) {
        cache.clean(byKey: id)
    }
}
