//
//  MWTitleArrowCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTitleArrowCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrowImage"))
        image.tintColor = UIColor(named: "textColor")
        image.alpha = 0.5
        return image
    }()
    
    private func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(16)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.titleLabel)
        self.accessoryView = self.arrowImageView
        self.selectionStyle = .none
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
