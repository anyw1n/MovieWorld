//
//  MWMovieCardView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/5/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieCardView: UIView {
    
    // MARK: - variables
    
    private let imageInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
    private let textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    private let textOffset = 16
    private let imageSize = CGSize(width: 70, height: 100)
    
    // MARK: - gui variables

    private(set) lazy var posterImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.alpha = 0.5
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeConstraints() {
        self.posterImageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.imageInsets)
            make.bottom.lessThanOrEqualToSuperview().inset(self.imageInsets)
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
        self.subtitleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
        self.genreLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
        self.ratingLabel.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.genreLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
    }
    
    // MARK: - functions
    
    func setup(_ movie: Movieable) {
        movie.showImage(size: .w92, in: self.posterImageView)
        self.titleLabel.text = movie.title
        
        if let movie = movie as? MWMovie, movie.details == nil {
            movie.detailsLoaded = { [weak self] in
                self?.setSubtitle(movie: movie)
                self?.setNeedsUpdateConstraints()
            }
        } else if let movie = movie as? MWShow, movie.details == nil {
            movie.detailsLoaded = { [weak self] in
                self?.setSubtitle(movie: movie)
                self?.setNeedsUpdateConstraints()
            }
        }
        
        self.setSubtitle(movie: movie)
        self.genreLabel.text = movie.genres.joined(separator: ", ")
        self.ratingLabel.text = "IMDB -, KP -"
    }
    
    private func setSubtitle(movie: Movieable) {
        if let movie = movie as? MWMovie, let details = movie.details,
            !(details.countryNames.isEmpty) {
            self.subtitleLabel.text =
            "\(movie.releaseYear), \(details.countryNames.joined(separator: ", "))"
        } else if let movie = movie as? MWShow, let details = movie.details,
            !(details.countryNames.isEmpty) {
            self.subtitleLabel.text =
            "\(movie.releaseYear), \(details.countryNames.joined(separator: ", "))"
        } else {
            self.subtitleLabel.text = "\(movie.releaseYear)"
        }
    }
    
    private func addSubviews() {
        self.addSubview(self.posterImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.genreLabel)
        self.addSubview(self.ratingLabel)
    }
}
