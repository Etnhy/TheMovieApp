//
//  HomeView.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit

class HomeView: BaseView {
    
    private lazy var searchbar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search..."
        return searchbar
    }()
    
     lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseID)

        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(style: .medium)
        act.backgroundColor = .black.withAlphaComponent(0.75)
        return act
    }()


    override func setupViews() {
        [searchbar,tableView,activityIndicator].forEach(addSubview(_:))
    }
    
    override func setupConstraints() {
        searchbar.snp.remakeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchbar.snp.bottom).offset(12)
        }
        activityIndicator.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func startLoad() {
        activityIndicator.startAnimating()
    }
    
    func stopLoad() {
        activityIndicator.stopAnimating()

    }
    
    func setupTableView(_ dataSource: UITableViewDataSource,_ delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    func setupSearchbar(_ delegate: UISearchBarDelegate) {
        searchbar.delegate = delegate
    }
    
    func reloadTableView() {
        UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
    }
    
    func cleanSearchbar() {
        searchbar.text = ""
        resignFirstResponder()
    }
    
}
