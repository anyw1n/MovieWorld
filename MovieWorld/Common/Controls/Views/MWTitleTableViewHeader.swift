//
//  MWTitleTableViewHeader.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTitleTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - variables
    
    static let reuseId = "titleTableViewHeader"
    static let height: CGFloat = 62
    private let titleInsets = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
    
    // MARK: - gui variables
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    // MARK: - init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(self.titleInsets)
            make.bottom.right.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
