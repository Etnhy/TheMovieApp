//
//  HomeView.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit

class HomeView: BaseView {
    
     lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseID)

        return tableView
    }()


    override func setupViews() {
        [tableView].forEach(addSubview(_:))
    }
    
    override func setupConstraints() {
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func setupTableView(_ dataSource: UITableViewDataSource,_ delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    func reloadTableView() {
        UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
    }
    
}
