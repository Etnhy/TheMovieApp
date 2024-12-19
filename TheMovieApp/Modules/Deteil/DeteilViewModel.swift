//
//  DeteilViewModel.swift
//  TheMovieApp
//
//  Created by evhn on 17.12.2024.
//

import Foundation

struct DeteilViewViewModel {
    var movie: MovieDetailResponse
    var genres: [Genre] = []
    var cacheServise: ImageCache
    var imagePath: String?
}



final class DeteilViewModel {
    
    var movie: DeteilViewViewModel
    
    init(movie: DeteilViewViewModel) {
        self.movie = movie
    }
}
