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
    
    func showActionSheet(selected: SortedByState,_ compeltion: @escaping (SortedByState) -> Void) {
        let sheet = UIAlertController(title: "", message: "sorted by", preferredStyle: .actionSheet)
        
        SortedByState.allCases.forEach { item in
            let action = UIAlertAction(title: item.title, style: .default) { _ in
                compeltion(item)
            }
            if selected == item {
                action.setValue(UIImage(systemName: "checkmark"), forKey: "image")
            }

            sheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        sheet.addAction(cancelAction)
        
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.present(sheet, animated: true)
            
        }
    }

}
