//
//  HomeCoordinator.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        setupHome()
    }
    
    private func setupHome() {
        let vm = HomeViewModel()
        let home = HomeController(viewModel: vm, coordinator: self)
        navigationController.pushViewController(home, animated: false)
    }

}
