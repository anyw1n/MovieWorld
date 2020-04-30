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
    
    static let reuseID = "MWTagCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            self.contentView.alpha = self.isSelected ? 1 : 0.5
        }
    }
    
    //MARK: - gui variables

    private(set) lazy var button: MWRoundedButton = {
        let button = MWRoundedButton()
        button.isUserInteractionEnabled = false
        button.titleEdgeInsets = UIEdgeInsets.zero
        return button
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.button)
        self.contentView.alpha = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - constraints
    
    override func updateConstraints() {
        self.button.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        super.updateConstraints()
    }
}
