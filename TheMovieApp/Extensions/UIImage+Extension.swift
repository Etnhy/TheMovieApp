//
//  UIImage+Extension.swift
//  TheMovieApp
//
//  Created by evhn on 17.12.2024.
//

import UIKit
import Combine
import Alamofire

extension UIImage {
    func resized(by scale: CGFloat) -> UIImage? {
        guard scale > 0 && scale <= 1 else { return nil }
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


extension UIImageView {

    func loadImage(
        from urlString: String,
        cache: ImageCacheProtocol,
        imageId: String,
        size: ImageSizeType = .small
    ) -> AnyCancellable? {
        
        if let cachedImage = cache.getImage(imageId: imageId, for: size) {
            self.image = cachedImage
            return nil
        }
        

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return AF.request("https://image.tmdb.org/t/p/original\(urlString)")
            .publishData()
            .tryMap { response in
                guard let data = response.data, let image = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                return image
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                switch completion {
                case .failure(let error):
                    print("load error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] image in
                cache.saveImage(imageId: imageId, image: image)
                self?.image = cache.getImage(imageId: imageId, for: size) ?? image
            }
    }
}
