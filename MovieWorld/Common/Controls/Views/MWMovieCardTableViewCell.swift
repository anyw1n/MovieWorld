//
//  MWMovieCardTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/16/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovieCardTableViewCell: UITableViewCell {
    
    //MARK: - variables
    
    static let reuseID = "movieCardTableViewCell"
    private let imageInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
    private let textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    private let textOffset = 16
    private let imageSize = CGSize(width: 70, height: 100)
    
    //MARK: - gui variables
    
    private lazy var posterImageView: UIImageView = {
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

    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.addSubviews()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.posterImageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.imageInsets)
            make.bottom.lessThanOrEqualToSuperview().inset(self.imageInsets)
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
        self.genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
        self.ratingLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.genreLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.left.equalTo(self.posterImageView.snp.right).offset(self.textOffset)
            make.right.equalToSuperview().inset(self.textInsets)
        }
    }
    
    //MARK: - functions
    
    private func addSubviews() {
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.contentView.addSubview(self.genreLabel)
        self.contentView.addSubview(self.ratingLabel)
    }
    
    func setup(_ movie: MWMovie) {
        self.posterImageView.image = movie.image
        self.titleLabel.text = movie.title
        self.subtitleLabel.text = "\(movie.releaseYear)"
        self.genreLabel.text = movie.genres.joined(separator: ", ")
        self.ratingLabel.text = "IMDB 8.2, KP 8.3"
        movie.imageLoaded = { id in
            if id == movie.id {
                self.posterImageView.image = movie.image
            }
        }
    }
}
