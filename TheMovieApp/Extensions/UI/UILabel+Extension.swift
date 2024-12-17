//
//  UILabel+Extension.swift
//  TheMovieApp
//
//  Created by evhn on 17.12.2024.
//

import UIKit

extension UILabel {
    
    convenience init(fontSize: CGFloat,fontWeight: UIFont.Weight = .medium, foregroundColor: UIColor,_ alignment: NSTextAlignment = .left) {
        self.init()
        font = .systemFont(ofSize: fontSize,weight: fontWeight)
        textColor = foregroundColor
        textAlignment = alignment
    }
}
