//
//  DeteilController.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit

class DeteilController: BaseViewController {

    var viewModel: DeteilViewModel
    var coordinator: HomeCoordinator
    
    private lazy var deteilView = DeteilView()
    
    
    
    init(movie: DeteilViewViewModel, coordinator: HomeCoordinator) {
        self.viewModel = DeteilViewModel(movie: movie)
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setTitle(movie.movie.title)
        deteilView.setupView(model: movie.movie,vote: movie.voteAverage ?? 0)
        deteilView.loadImage(movie.imagePath, cache: movie.cacheServise)
        print(movie.movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = deteilView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deteilView.trailerButtonAction = { [weak self] in

        }
        
    }

    
}
