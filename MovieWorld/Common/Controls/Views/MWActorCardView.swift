//
//  MWActorCardView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/23/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWActorCardView: UIView {
    
    // MARK: - variables
    
    private let imageSize = CGSize(width: 70, height: 70)
    private let imageInsets = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 0)
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
    
    private lazy var birthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "textColor")
        label.alpha = 0.5
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.profileImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.birthLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeConstraints() {
        self.profileImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(self.imageInsets)
            make.bottom.lessThanOrEqualToSuperview()
            make.size.equalTo(self.imageSize)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.imageInsets)
            make.left.equalTo(self.profileImageView.snp.right).offset(self.offset)
            make.right.lessThanOrEqualToSuperview()
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            make.left.equalTo(self.profileImageView.snp.right).offset(self.offset)
            make.right.lessThanOrEqualToSuperview()
        }
        self.birthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(1)
            make.left.equalTo(self.profileImageView.snp.right).offset(self.offset)
            make.right.lessThanOrEqualToSuperview().offset(-self.offset)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - functions
    
    func setup(actor: MWActor) {
        actor.showProfileImage(size: .w92, in: self.profileImageView)
        self.titleLabel.text = String(actor.name.split(separator: " ").first ?? "")
        self.subtitleLabel.text =
            actor.name.split(separator: " ").dropFirst().joined(separator: " ")
        
        if let details = actor.details {
            self.setBirth(details: details)
        } else {
            actor.detailsLoaded = { [weak self] in
                self?.setBirth(details: actor.details)
            }
        }
    }
    
    private func setBirth(details: MWActorDetails?) {
        guard let details = details, let birthDate = details.birthDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        if let deathDate = details.deathDate {
            let age = Calendar.current.dateComponents([.year],
                                                      from: birthDate,
                                                      to: deathDate)
            
            self.birthLabel.text = "%@-%@ (%d years)"
                .localized(args: dateFormatter.string(from: birthDate),
                           dateFormatter.string(from: deathDate),
                           age.year ?? 0)
        } else {
            let age = Calendar.current.dateComponents([.year],
                                                      from: birthDate,
                                                      to: Date())
            
            self.birthLabel.text = "%@ to date (%d years)"
                .localized(args: dateFormatter.string(from: birthDate), age.year ?? 0)
        }
    }
}
