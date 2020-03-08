//
//  MWCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCollectionViewCell: UICollectionViewCell {
    
    //MARK: - variables
    
    static let reuseID = "imageTitleDescriptionCell"
    private let imageSize = CGSize(width: 130, height: 185)
    
    //MARK: - gui variables
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.imageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        self.subtitleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - functions
    
    private func addSubviews() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.makeConstraints()
    }
}
