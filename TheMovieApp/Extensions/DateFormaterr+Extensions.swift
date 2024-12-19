//
//  DateFormaterr+Extensions.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import Foundation

extension DateFormatter {
    static let releaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        return formatter
    }()
}
