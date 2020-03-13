//
//  MWTableViewHeader.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTableViewHeader: UITableViewHeaderFooterView {
    
    //MARK: - variables
    
    static let reuseID = "titleButtonHeaderView"
    
    private let titleInsets = UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 0)
    private let buttonInsets = UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 7)
    private let buttonSize = CGSize(width: 52, height: 24)
    
    //MARK: - gui variables
    
    private(set) lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 24)
        title.textColor = UIColor(named: "textColor")
        return title
    }()
    
    private(set) lazy var rightButton =
        MWRoundedButton(text: "All".localized(), image: UIImage(named: "nextIcon"))
    
    //MARK: - init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.rightButton)
        self.contentView.backgroundColor = .white
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - constraints
    
    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(self.titleInsets)
        }
        self.rightButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(self.buttonInsets)
            make.size.equalTo(self.buttonSize)
        }
    }
}
