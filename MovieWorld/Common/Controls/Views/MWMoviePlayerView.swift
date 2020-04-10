//
//  MWMoviePlayerView.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/10/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMoviePlayerView: UIView {

    // MARK: - variables
    
    private let likeIconSize = CGSize(width: 18, height: 20)
    
    // MARK: - gui variables
    
    private lazy var player: UIView = UIView()
    
    private lazy var dislikeImageView: UIImageView =
        UIImageView(image: UIImage(named: "dislikeImage"))

    private lazy var likeImageView: UIImageView =
        UIImageView(image: UIImage(named: "likeImage"))

    private lazy var likesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    private lazy var dislikesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "textColor")
        return label
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.player)
        self.addSubview(self.dislikesCountLabel)
        self.addSubview(self.dislikeImageView)
        self.addSubview(self.likesCountLabel)
        self.addSubview(self.likeImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    func makeInternalConstraints() {
        self.player.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(166)
        }
        self.dislikesCountLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.player.snp.bottom)
            make.right.bottom.equalToSuperview()
        }
        self.dislikeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.player.snp.bottom).offset(16)
            make.right.equalTo(self.dislikesCountLabel.snp.left).offset(-3)
            make.size.equalTo(self.likeIconSize)
            make.bottom.equalToSuperview()
        }
        self.likesCountLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.player.snp.bottom)
            make.right.equalTo(self.dislikeImageView.snp.left).offset(-16)
            make.bottom.equalToSuperview()
        }
        self.likeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.player.snp.bottom).offset(16)
            make.right.equalTo(self.likesCountLabel.snp.left).offset(-3)
            make.left.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(self.likeIconSize)
        }
    }
}
