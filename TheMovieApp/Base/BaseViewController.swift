//
//  BaseViewController.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit

class BaseViewController: UIViewController {

    
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
}
