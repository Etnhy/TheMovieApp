//
//  HomeViewModel.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import Foundation
import Combine

enum SortedByState: Int, CaseIterable {
    case popularity, name, releaseDate
    var title: String {
        switch self {
        case .popularity: return "by popularity"
        case .name: return "by name"
        case .releaseDate: return " by release date"
        }
    }
}

final class HomeViewModel {
    private let movieService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var totalPages = Int.max
    
    @Published var genres: [Genre] = []

    @Published var movies: [Movie] = []
    private var allMovies: [Movie] = []
    @Published var isLoading: Bool = false
    
    @Published var selectedSorting: SortedByState = .popularity
    var cacheService = ImageCache()
    
    init(movieService: NetworkService = NetworkService()) {
        self.movieService = movieService
        
        binding()
        fetchGenres()
    }

    func fetchMovies(for page: Int) {
        guard /*!isLoading,*/ page <= totalPages else { return }
//        isLoading = true
        
        movieService.fetchPopular(page: page)
            .map(\.results)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error loading movies: \(error)")
                }
            } receiveValue: { [weak self] newMovies in
                guard let self else { return }
                self.movies.append(contentsOf: newMovies)
                self.allMovies.append(contentsOf: newMovies)
                self.currentPage = page
//                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func goToDeteil(voteAverage: Double?,response: MovieDetailResponse, imagePath: String?) -> DeteilViewViewModel {
        DeteilViewViewModel(movie: response, genres: genres, cacheServise: cacheService, imagePath: imagePath, voteAverage: voteAverage)
    }
    
    func fetchGenres() {
        movieService.fetchAllGenres()
            .sink {  completion in
                if case .failure(let error) = completion {
                    print("Error loading movies: \(error)")
                }
            } receiveValue: { [weak self] newMovies in
                guard let self else { return }
                self.genres.append(contentsOf: newMovies.genres)
            }
            .store(in: &cancellables)
    }
    
    func getDeteil(voteAverage: Double?,posterPath: String?,for id: Int, completion: @escaping (DeteilViewViewModel) -> Void) {
        self.isLoading = true
        movieService.getDeteilMoview(id: id)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error loading movies: \(error)")
                }
            } receiveValue: { response in
                let model = self.goToDeteil(voteAverage: voteAverage, response: response, imagePath: posterPath)
                completion(model)
            }
            .store(in: &cancellables)

    }
    
    func fetchNextPage() {
        fetchMovies(for: currentPage + 1)
    }

    
    private func binding() {
        $selectedSorting
            .sink { sorting in
                self.sortedBy()
            }
            .store(in: &cancellables)
    }
    
    private func sortedBy() {
        switch selectedSorting {
        case .popularity:
            self.movies.sort(by: { $0.popularity > $1.popularity })

        case .name:
            movies.sort { $0.title.lowercased() < $1.title.lowercased() }

        case .releaseDate:
            self.movies.sort(by: { lhs, rhs in

                let lhsDate = lhs.releaseDate.flatMap { DateFormatter.releaseDateFormatter.date(from: $0) }
                let rhsDate = rhs.releaseDate.flatMap { DateFormatter.releaseDateFormatter.date(from: $0) }
                if let lhsDate = lhsDate, let rhsDate = rhsDate {
                    return lhsDate > rhsDate
                }
                return lhsDate != nil
            })
        }
    }
    
    func filterMovies(by query: String) {
        if query.isEmpty {
            movies = allMovies
        } else {
            movies = allMovies.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
    
    func resetMovies() {
        movies = allMovies
    }
}
