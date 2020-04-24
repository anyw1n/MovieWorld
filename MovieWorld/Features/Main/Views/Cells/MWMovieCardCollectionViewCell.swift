//
//  MWCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieCardCollectionViewCell: MWCollectionViewCell {
    
    // MARK: - variables

    private let imageSize = CGSize(width: 130, height: 185)
    override class var reuseId: String { "movieCardCollectionViewCell" }
    override class var itemSize: CGSize { CGSize(width: 130, height: 237) }

    // MARK: - gui variables
    
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
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.imageView.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.imageView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        self.subtitleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.left.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - functions
    
    override func setup<T>(_ item: T) {
        guard let movie = item as? Movieable else { return }
        
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
}
