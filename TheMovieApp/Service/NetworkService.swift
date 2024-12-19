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
    func fetchAllGenres() -> AnyPublisher<Genres, Error>
    func getDeteilMoview(id: Int) -> AnyPublisher<MovieDetailResponse, Error>
}

enum Endpoint {
    case movie(page: Int)
    case genre
    case deteilMovie(id: Int)
    
    var path: String {
        switch self {
        case .movie(let page): 
            return "/movie/popular?page=\(page)"
        case .genre: 
            return "genre/movie/list?language=en"
        case .deteilMovie(let id): 
            return "movie/\(id)"
        }
    }
}

final class NetworkService: NetworkServiceProtocol {

    
    private let baseURL = "https://api.themoviedb.org/3/"
    private let headers: HTTPHeaders = [
        "Authorization": "Bearer \(AppConstants.apiKey)",
        "Accept": "application/json"
    ]
    
    
    func fetchPopular(page: Int) -> AnyPublisher<MovieResponse, Error> {
        fetch(endPoint: .movie(page: page))
    }

    func fetchAllGenres() -> AnyPublisher<Genres, Error> {
        fetch(endPoint: .genre)
    }
    
    func getDeteilMoview(id: Int) -> AnyPublisher<MovieDetailResponse, any Error> {
        fetch(endPoint: .deteilMovie(id: id))
    }
    

    private func fetch<T: Codable> (endPoint: Endpoint) -> AnyPublisher<T, Error> {
        let url = "\(baseURL)\(endPoint.path)"
        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError {$0 as Error}
            .eraseToAnyPublisher()

    }
    
}

