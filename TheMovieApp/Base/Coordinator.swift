//
//  Coordinator.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//


import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
    func pop()
    func popToRoot()
}

extension Coordinator {
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    func pop() {
        navigationController.popViewController(animated: true)
    }

}