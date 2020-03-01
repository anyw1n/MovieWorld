//
//  MWCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "imageTitleDescriptionCell"
    private let imageSize = CGSize(width: 130, height: 185)
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bookImage")
        view.layer.cornerRadius = 5
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Green Book"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2018, USA"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private func addSubviews() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.makeConstraints()
    }
    
    private func makeConstraints() {
        self.imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(self.imageSize)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
            make.height.equalTo(22)
            make.left.equalToSuperview()
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(18)
            make.left.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
