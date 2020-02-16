//
//  MWCardView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/16/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCardView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bookImage")
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Green Book"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return titleLabel
    }()
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "2018, USA"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        return subtitleLabel
    }()
    private lazy var genreLabel: UILabel = {
        let genreLabel = UILabel()
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.text = "Comedy, Drama, Foreign"
        genreLabel.font = UIFont.systemFont(ofSize: 13)
        genreLabel.textColor = UIColor(named: "textColor")
        return genreLabel
    }()
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "IMDB 8.2, KP 8.3"
        ratingLabel.font = UIFont.systemFont(ofSize: 13)
        return ratingLabel
    }()
    
    private func addSubviews() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.genreLabel)
        self.addSubview(self.ratingLabel)
        //self.makeConstraintsByAnchors()
        self.makeConstraintsBySnapKit()
    }
    
    private func makeConstraintsByAnchors() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.genreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 70),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor,
                                                     constant: 16),
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,
                                                    constant: 5),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor,
                                                        constant: 16),
            self.genreLabel.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor,
                                                 constant: 5),
            self.genreLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor,
                                                     constant: 16),
            self.ratingLabel.topAnchor.constraint(equalTo: self.genreLabel.bottomAnchor,
                                                  constant: 24),
            self.ratingLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor,
                                                      constant: 16)
        ])
    }
    
    private func makeConstraintsBySnapKit() {
        self.imageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.width.equalTo(70)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.imageView.snp.right).offset(16)
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.imageView.snp.right).offset(16)
        }
        self.genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(5)
            make.left.equalTo(self.imageView.snp.right).offset(16)
        }
        self.ratingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.genreLabel.snp.bottom).offset(24)
            make.left.equalTo(self.imageView.snp.right).offset(16)
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .white
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .white
        self.addSubviews()
    }
}
