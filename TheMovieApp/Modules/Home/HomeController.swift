//
//  HomeController.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit
import Combine

class HomeController: BaseViewController {

    var viewModel: HomeViewModel
    var coordinator: HomeCoordinator
    
    private lazy var homeView: HomeView = {
        let view = HomeView()
        view.setupTableView(self, self)
        view.setupSearchbar(self)
        return view
    }()
    
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModel, coordinator: HomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func loadView() {
        super.loadView()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setTitle("Popular Movies")
        viewModel.fetchMovies(for: 1)
        makeRightButton(#selector(showSortedMenu))
    }

    
    private func setupBindings() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.homeView.reloadTableView()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.homeView.startLoad()
                } else {
                    self?.homeView.stopLoad()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func showSortedMenu() {
        coordinator.showActionSheet(selected: viewModel.selectedSorting) {[weak self] sort in
            guard let self else { return }
            viewModel.selectedSorting = sort
        }
    }

    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseID, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
        
        let movie = viewModel.movies[indexPath.row]
        cell.setupCell(with: movie, cache: viewModel.cacheService, genres: viewModel.genres)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = viewModel.movies[indexPath.row]
        print(movieId)
        viewModel.getDeteil(voteAverage: movieId.voteAverage, posterPath: movieId.posterPath, for: movieId.id) {[weak self] moviewResponse in
            guard let self else {return}
            coordinator.showDeteil(movie: moviewResponse)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2 {
            viewModel.fetchNextPage()
            viewModel.resetMovies()
            homeView.cleanSearchbar()
            resignAndCloseKeyboard()
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension HomeController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterMovies(by: searchText)
    }
}
