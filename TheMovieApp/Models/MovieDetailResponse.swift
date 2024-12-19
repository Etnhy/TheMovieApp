//
//  MovieDetailResponse.swift
//  TheMovieApp
//
//  Created by evhn on 17.12.2024.
//



struct MovieDetailResponse: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String?
    let originCountry: [String]?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double?
    let voteCount: Int?

}

struct BelongsToCollection: Codable {
    let id: Int
    let name, posterPath, backdropPath: String
}


struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
}


struct ProductionCountry: Codable {
    let iso3166_1, name: String
}

struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String
}
