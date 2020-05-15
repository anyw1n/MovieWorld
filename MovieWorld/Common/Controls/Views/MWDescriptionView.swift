//
//  MWDescriptionView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/10/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWDescriptionView: UIView {

    // MARK: - variables

    private let offset = 16
    private let contentInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    private var additionalInfoEnabled: Bool = false

    // MARK: - gui variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    private(set) lazy var definitionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        label.alpha = 0.5
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        label.alpha = 0.5
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 0
        return label
    }()

    // MARK: - init

    init(additionalInfoEnabled: Bool) {
        super.init(frame: CGRect())
        self.additionalInfoEnabled = additionalInfoEnabled
        self.addSubview(self.titleLabel)
        if additionalInfoEnabled {
            self.addSubview(self.definitionLabel)
            self.addSubview(self.subtitleLabel)
        }
        self.addSubview(self.textLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints

    func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().inset(self.contentInsets)
            make.right.lessThanOrEqualToSuperview()
        }
        if self.additionalInfoEnabled {
            self.definitionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(self.offset)
                make.left.equalToSuperview().inset(self.contentInsets)
            }
            self.subtitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(self.offset)
                make.left.equalTo(self.definitionLabel.snp.right).offset(self.offset)
                make.right.lessThanOrEqualToSuperview()
            }
            self.textLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.subtitleLabel.snp.bottom).offset(8)
            }
        } else {
            self.textLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(self.offset)
            }
        }
        self.textLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.contentInsets)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - functions

    func setup(title: String?, definition: String? = nil, subtitle: String? = nil, text: String?) {
        self.titleLabel.text = title
        if self.additionalInfoEnabled {
            self.definitionLabel.text = definition
            self.subtitleLabel.text = subtitle
        }
        self.textLabel.text = text
    }
}
