//
//  BaseViewController.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    private let networkStatus = NetworkConnectionService.shared
    
    private var networkCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }

    func makeRightButton(_ target: Selector) {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
        button.addTarget(self, action: target, for: .touchUpInside)
    }
    
    func resignAndCloseKeyboard() {
        resignFirstResponder()
        view.endEditing(true)
    }
    
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func bindings() {
        networkCancellable = networkStatus.$isConnected
            .filter({!$0})
            .sink { [weak self] status in
                guard let self else { return }
                self.showAlert(title: "Error", message: "No internet connection")
            }
    }
    
    @objc func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
