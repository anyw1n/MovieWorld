//
//  MWCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - variables
    
    static let reuseId = "movieCardCollectionViewCell"
    private let imageSize = CGSize(width: 130, height: 185)
    
    // MARK: - gui variables
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        self.addSubviews()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.imageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.imageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        self.subtitleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(_ movie: Movieable) {
        self.titleLabel.text = movie.title
        self.subtitleLabel.text = "\(movie.releaseYear), \(movie.genres.first ?? "")"
        if let movie = movie as? MWShow, movie.details == nil {
            movie.detailsLoaded = {
                self.subtitleLabel.text =
                "\(movie.releaseYear), \(movie.genres.first ?? "")"
                self.setNeedsUpdateConstraints()
            }
        }
        movie.showImage(size: .w154, in: self.imageView)
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
    }
}
