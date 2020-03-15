//
//  MWTagCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/15/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTagCollectionViewCell: UICollectionViewCell {
    
    //MARK: - variables
    
    static let reuseID = "tagCollectionViewCell"
    private let titleInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    override var isSelected: Bool {
        didSet {
            self.contentView.alpha = self.isSelected ? 1 : 0.5
        }
    }
    
    //MARK: - gui variables
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = UIColor(named: "accentColor")
        self.contentView.alpha = 0.5
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.titleInsets)
            make.height.equalTo(18)
        }
    }
}
