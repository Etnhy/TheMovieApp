//
//  NetworkService.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import Foundation
import Combine
import Alamofire


protocol NetworkServiceProtocol {
    func fetchPopular(page: Int) -> AnyPublisher<MovieResponse, Error>
    func fetchAllGenres() -> AnyPublisher<[Genre], Error>
    func getDeteilMoview(id: Int) -> AnyPublisher<MovieDetailResponse, Error>
}

enum Endpoint: String {
    case movie = "/movie/popular"
    case genre = "genre/movie/list?language=en"
    case deteilMovie = "movie/"
}

final class NetworkService: NetworkServiceProtocol {

    
    private let baseURL = "https://api.themoviedb.org/3/"
    private let headers: HTTPHeaders = [
        "Authorization": "Bearer \(AppConstants.apiKey)",
        "Accept": "application/json"
    ]
    
    
    func fetchPopular(page: Int) -> AnyPublisher<MovieResponse, Error> {
        let url = "\(baseURL)\(Endpoint.movie.rawValue)?page=\(page)"
        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: MovieResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchAllGenres() -> AnyPublisher<[Genre], Error> {
        let url = "\(baseURL)\(Endpoint.genre.rawValue)"
        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: Genres.self)
            .value()
            .mapError { $0 as Error }
            .map(\.genres)
            .eraseToAnyPublisher()
    }
    
    func getDeteilMoview(id: Int) -> AnyPublisher<MovieDetailResponse, any Error> {
        let url = "\(baseURL)\(Endpoint.deteilMovie.rawValue)\(id)?"
        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: MovieDetailResponse.self)
            .value()
            .mapError {$0 as Error}
            .eraseToAnyPublisher()
    }
    

    
    
}

