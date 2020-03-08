//
//  MWCardView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/16/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCardView: UIView {
    
    //MARK: - variables
    
    private let imageInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 0)
    private let imageSize = CGSize(width: 70, height: 100)
    
    //MARK: - gui variables
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
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
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
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
    
    init() {
        super.init(frame: CGRect())
        
        self.backgroundColor = .white
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .white
        self.addSubviews()
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.imageView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview().inset(self.imageInsets)
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.imageView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.left.equalTo(self.imageView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
        self.genreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.imageView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
        self.ratingLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(8)
            make.left.equalTo(self.imageView.snp.right).offset(16)
            make.right.equalToSuperview()
        }
    }
    
    //MARK: - functions
    
    private func addSubviews() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.genreLabel)
        self.addSubview(self.ratingLabel)
        self.makeConstraints()
    }
}
