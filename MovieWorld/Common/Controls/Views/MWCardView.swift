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
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Green Book"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor(named: "textColor")
        return titleLabel
    }()
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "2018, USA"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = UIColor(named: "textColor")
        return subtitleLabel
    }()
    private lazy var genreLabel: UILabel = {
        let genreLabel = UILabel()
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.text = "Comedy, Drama, Foreign"
        genreLabel.font = UIFont.systemFont(ofSize: 13)
        genreLabel.numberOfLines = 2
        genreLabel.alpha = 0.5
        genreLabel.textColor = UIColor(named: "textColor")
        return genreLabel
    }()
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "IMDB 8.2, KP 8.3"
        ratingLabel.font = UIFont.systemFont(ofSize: 13)
        ratingLabel.textColor = UIColor(named: "textColor")
        return ratingLabel
    }()
    
    private func addSubviews() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.genreLabel)
        self.addSubview(self.ratingLabel)
        self.makeConstraintsBySnapKit()
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
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.left.equalTo(self.imageView.snp.right).offset(16)
        }
        self.genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.imageView.snp.right).offset(16)
        }
        self.ratingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.genreLabel.snp.bottom).offset(8)
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
