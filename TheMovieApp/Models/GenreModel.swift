//
//  GenreModel.swift
//  TheMovieApp
//
//  Created by evhn on 17.12.2024.
//

import Foundation

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
