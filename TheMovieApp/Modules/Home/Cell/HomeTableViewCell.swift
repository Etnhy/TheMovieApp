//
//  HomeTableViewCell.swift
//  TheMovieApp
//
//  Created by evhn on 16.12.2024.
//

import UIKit
import Combine

class HomeTableViewCell: UITableViewCell {
    
    static let reuseID = String(describing: HomeTableViewCell.self)
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var title = UILabel(fontSize: 26,fontWeight: .bold, foregroundColor: .white)
    private lazy var genre = UILabel(fontSize: 16, foregroundColor: .white)
    private lazy var rating = UILabel(fontSize: 16, foregroundColor: .white, .right)
    
    private var cancellable: AnyCancellable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [cellImageView,title,genre,rating].forEach(addSubview(_:))
        
        setupCons()
    }
    
    private func setupCons() {
        cellImageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        title.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        genre.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        rating.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(genre)
        }
    }
    
    func setupCell(with movie: Movie, cache: ImageCacheProtocol, genres: [Genre]) {
        title.text = movie.title + ", " + (movie.releaseDate ?? "")
        rating.text = "Rating: \(movie.voteAverage)"
        setupGenres(with: movie.genreIDs, genres: genres)
        if let poster = movie.backdropPath {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                cancellable = cellImageView.loadImage(from: poster, cache: cache, imageId: poster)
                
            }
            
        }
    }
    
    private func setupGenres(with genresIds: [Int], genres: [Genre]) {
        let filteredGenres = genres.filter { genresIds.contains($0.id) }
        let genreNames = filteredGenres.map { $0.name }.joined(separator: ", ")
        genre.text = genreNames
    }
}
