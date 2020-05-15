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
    private let offset = 16

    private var videoId: String?
    private var playerSize: CGSize?

    // MARK: - gui variables

    private lazy var player: MWPlayer = {
        let player = MWPlayer()
        player.layer.cornerRadius = 5
        player.clipsToBounds = true
        return player
    }()

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

    func makeConstraints() {
        self.player.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(166)
        }
        self.dislikesCountLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.player.snp.bottom)
            make.right.bottom.equalToSuperview()
        }
        self.dislikeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.player.snp.bottom).offset(self.offset)
            make.right.equalTo(self.dislikesCountLabel.snp.left).offset(-3)
            make.size.equalTo(self.likeIconSize)
            make.bottom.equalToSuperview()
        }
        self.likesCountLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.player.snp.bottom)
            make.right.equalTo(self.dislikeImageView.snp.left).offset(-self.offset)
            make.bottom.equalToSuperview()
        }
        self.likeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.player.snp.bottom).offset(self.offset)
            make.right.equalTo(self.likesCountLabel.snp.left).offset(-3)
            make.left.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(self.likeIconSize)
        }
    }

    // MARK: - functions

    override func layoutSubviews() {
        let width = self.player.bounds.size.width
        guard self.playerSize == nil,
            let videoId = self.videoId,
            !width.isZero else { return }

        YTApi.sh.request(
            videoId: videoId,
            parameters: ["maxWidth": width]) { [weak self] (response: YoutubeDataVideoPlayer) in
                if let width = Int(response.player.embedWidth ?? ""),
                    let height = Int(response.player.embedHeight ?? "") {
                    self?.playerSize = CGSize(width: width, height: height)
                }
        }
    }

    func setup(video: MWMovieVideo) {
        self.videoId = video.key
        self.player.setup(video)
        self.player.playTapped = { [weak self] in
            guard let self = self, let height = self.playerSize?.height else { return false }

            self.player.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            self.superview?.setNeedsUpdateConstraints()

            UIView.animate(withDuration: 0.35, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { (_) in
                self.player.play()
            })
            return true
        }

        YTApi.sh.request(videoId: video.key) { [weak self] (response: YoutubeDataVideoStatistics) in
                self?.dislikesCountLabel.text = response.statistics.dislikeCount
                self?.likesCountLabel.text = response.statistics.likeCount
        }
    }
}
