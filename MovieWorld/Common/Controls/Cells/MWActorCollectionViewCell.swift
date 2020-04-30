//
//  MWActorCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/6/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWActorCollectionViewCell: MWCollectionViewCell {

    // MARK: - variables

    private let imageSize = CGSize(width: 72, height: 72)
    override class var reuseId: String { "MWActorCollectionViewCell" }
    override class var itemSize: CGSize { CGSize(width: 72, height: 124) }

    // MARK: - gui variables

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

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    override func updateConstraints() {
        self.imageView.snp.updateConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        self.subtitleLabel.snp.updateConstraints { (make) in
            make.top.lessThanOrEqualTo(self.titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        super.updateConstraints()
    }

    // MARK: - functions

    override func setup<T>(_ item: T) {
        guard let actor = item as? MWActor else { return }

        actor.showProfileImage(size: .w92, in: self.imageView)
        self.titleLabel.text = String(actor.name.split(separator: " ").first ?? "")
        self.subtitleLabel.text =
            actor.name.split(separator: " ").dropFirst().joined(separator: " ")
    }
}
