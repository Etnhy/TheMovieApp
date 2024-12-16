//
//  BaseView.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit
import SnapKit

class BaseView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {}
    func setupConstraints() {}

}
