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
    
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    
    @Published var selectedSorting: SortedByState = .popularity
    
    init(movieService: NetworkService = NetworkService()) {
        self.movieService = movieService
    }

    func fetchMovies(for page: Int) {
        guard !isLoading, page <= totalPages else { return }
        isLoading = true
        
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
                print(self.movies.map(\.releaseDate))
                self.currentPage = page
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func fetchNextPage() {
        fetchMovies(for: currentPage + 1)
    }

    
    private func sortedBy() {
        switch selectedSorting {
        case .popularity:
            self.movies.sort(by: { $0.popularity > $1.popularity })

        case .name:
            self.movies.sort(by: { $0.title > $1.title })

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
}
