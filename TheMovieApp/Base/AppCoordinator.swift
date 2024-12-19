//
//  AppCoordinator.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit


final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        startWithHome()
    }
    
    func startWithHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
    
}
