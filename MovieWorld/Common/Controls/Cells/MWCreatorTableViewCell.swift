//
//  MWCreatorTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWCreatorTableViewCell: UITableViewCell {

    // MARK: - variables

    static let reuseId = "MWCreatorTableViewCell"

    static let height: CGFloat = 44

    private let insets = UIEdgeInsets(top: 11, left: 16, bottom: 0, right: 0)

    // MARK: - gui variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - constraints

    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.left.top.equalToSuperview().inset(self.insets)
            make.right.bottom.lessThanOrEqualToSuperview()
        }
        super.updateConstraints()
    }

    // MARK: - functions

    func setup(creator: MWCreator) {
        self.titleLabel.text = creator.name
    }
}
