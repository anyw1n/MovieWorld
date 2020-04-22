//
//  MWActorTableViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWActorTableViewCell: UITableViewCell {
    
    // MARK: - variables
    
    static let reuseId = "actorTableViewCell"
    private let imageSize = CGSize(width: 70, height: 70)
    private let imageInsets = UIEdgeInsets(top: 10, left: 16, bottom: 13, right: 0)
    private let offset = 16
    
    // MARK: - gui variables
    
    private(set) lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.profileImageView.snp.updateConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(self.imageInsets)
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(self.imageInsets)
            make.left.equalTo(self.profileImageView.snp.right).offset(self.offset)
            make.right.lessThanOrEqualToSuperview()
        }
        self.subtitleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.left.equalTo(self.profileImageView.snp.right).offset(self.offset)
            make.right.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(actor: MWActor) {
        actor.showProfileImage(size: .w92, in: self.profileImageView)
        self.titleLabel.text = String(actor.name.split(separator: " ").first ?? "")
        self.subtitleLabel.text =
            actor.name.split(separator: " ").dropFirst().joined(separator: " ")
    }
}
