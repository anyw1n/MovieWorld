//
//  MWTitleArrowCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTitleArrowCell: UITableViewCell {

    // MARK: - variables

    static let reuseID = "MWTitleArrowCell"

    private let titleInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 0)

    // MARK: - gui variables

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrowImage"))
        image.tintColor = UIColor(named: "textColor")
        image.alpha = 0.5
        return image
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.accessoryView = self.arrowImageView
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.titleInsets)
            make.right.lessThanOrEqualToSuperview()
        }
        super.updateConstraints()
    }
}
