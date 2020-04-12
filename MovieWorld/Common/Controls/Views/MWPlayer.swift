//
//  MWPlayer.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/10/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import YoutubePlayerView

class MWPlayer: UIView {

    // MARK: - variables
    
    private let playImageSize = CGSize(width: 52, height: 52)
    var defaultPlayerParameters: [String: Any] =
        ["hl": Locale.current.languageCode ?? "en",
         "controls": 2,
         "iv_load_policy": 3,
         "modestbranding": 1,
         "playsinline": 1,
         "rel": 0,
         "autoplay": 1]
    var playTapped: (() -> Bool)?
    var videoId: String?
    
    // MARK: - gui variables
    
    private lazy var thumbnail: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.addSubview(self.imageOverlay)
        view.addSubview(self.playButton)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var imageOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "textColor")
        view.alpha = 0.5
        return view
    }()
    
    private lazy var playButton: UIImageView = {
        let view = UIImageView(image: UIImage(named: "playImage"))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(self.playButtonTapped)))
        return view
    }()
    
    private(set) lazy var player: YoutubePlayerView = {
        let view = YoutubePlayerView()
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.player)
        self.addSubview(self.thumbnail)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.thumbnail.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.imageOverlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.playButton.snp.makeConstraints { (make) in
            make.size.equalTo(self.playImageSize)
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    func setup(_ video: MWMovieVideo) {
        self.videoId = video.key
        video.showThumbnail(in: self.thumbnail)
    }
    
    func play() {
        self.player.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.player.loadWithVideoId(self.videoId ?? "", with: self.defaultPlayerParameters)
    }
    
    @objc private func playButtonTapped() {
        self.thumbnail.isHidden = true
        if !(self.playTapped?() ?? false) {
            self.thumbnail.isHidden = false
        }
    }
}
