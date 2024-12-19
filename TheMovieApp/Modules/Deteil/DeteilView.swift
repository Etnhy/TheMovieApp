//
//  DeteilView.swift
//  TheMovieApp
//
//  Created by evhn on 18.12.2024.
//

import UIKit
import Combine

final class DeteilView: BaseView {
    
    private lazy var scrollContainer: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    
    private lazy var deteilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel = UILabel(fontSize: 18, foregroundColor: .black)
    private lazy var countryYear = UILabel(fontSize: 18, foregroundColor: .black)
    private lazy var genreLabel = UILabel(fontSize: 18, foregroundColor: .black)
    
    private lazy var trailerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Trailer", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        return button
    }()
    private let ratingLabel = UILabel(fontSize: 16, foregroundColor: .black)
    
    private let textLabel = UILabel(fontSize: 16, foregroundColor: .black)
    
    private var cancellable: AnyCancellable?
    
    override func setupViews() {
        addSubview(scrollContainer)
        setupStack()
        textLabel.textAlignment = .center
    }
    
    override func setupConstraints() {
        scrollContainer.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
    }
    
    func setupView(model: MovieDetailResponse, vote: Double) {
        nameLabel.text = model.title
        countryYear.text = self.setupCountries(countreis: model.originCountry ?? []) + " " + (model.releaseDate ?? "")
        genreLabel.text = model.genres.map {$0.name}.joined(separator: ", ")
        ratingLabel.text = "Rating: \(vote)"
        textLabel.text = model.overview ?? ""
        trailerButton.layer.opacity = model.video ? 1 : 0
        
    }
    
    func loadImage(_ urlString: String?, cache: ImageCache) {
        if let poster = urlString {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.cancellable = self.deteilImageView.loadImage(from: poster, cache: cache, imageId: poster)
            }
            
        }
    }
    private func setupStack() {
        let hStack = UIStackView(arrangedSubviews: [trailerButton,ratingLabel])
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        
        let vStack = UIStackView(arrangedSubviews: [deteilImageView, nameLabel, countryYear, genreLabel,hStack,textLabel])
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.spacing = 12
        scrollContainer.addSubview(vStack)
        
        vStack.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollContainer.snp.width)
        }
    }
    
    
    private func setupCountries(countreis: [String]) -> String {
        let country = countreis.map { $0 }.joined(separator: ", ")
        return country
    }
    
    
}
