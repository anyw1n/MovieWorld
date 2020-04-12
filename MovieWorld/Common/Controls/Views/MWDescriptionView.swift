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
    
    // MARK: - gui variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description".localized()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private lazy var definitionLabel: UILabel = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.definitionLabel)
        self.addSubview(self.subtitleLabel)
        self.addSubview(self.textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeInternalConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.definitionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.offset)
            make.left.equalToSuperview()
        }
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.offset)
            make.left.equalTo(self.definitionLabel.snp.right).offset(self.offset)
            make.right.lessThanOrEqualToSuperview()
        }
        self.textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(_ movie: Movieable) {
        if let videoId = movie.details?.videos?.first(where: { $0.site == "YouTube" })?.key {
            YTApi.sh.request(
            videoId: videoId) { [weak self] (response: YoutubeDataVideoContentDetails) in
                self?.definitionLabel.text = response.contentDetails.definition.uppercased()
            }
        }
        self.subtitleLabel.text = "X minutes".localized(args: movie.details?.runtime ?? 0)
        self.textLabel.text = movie.overview
    }
}
