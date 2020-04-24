//
//  MWMediaCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMediaCollectionViewCell: MWCollectionViewCell {
    
    // MARK: - variables
    
    override class var reuseId: String { "mediaCollectionViewCell" }
    override class var itemSize: CGSize { CGSize(width: 180, height: 87) }
    var isWidthCalculated: Bool = false
    
    // MARK: - gui variables
    
    private(set) lazy var playerView: MWPlayer = {
        let player = MWPlayer()
        player.defaultPlayerParameters["playsinline"] = 0
        player.defaultPlayerParameters["controls"] = 0
        player.layer.cornerRadius = 5
        player.clipsToBounds = true
        player.isHidden = true
        return player
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.playerView)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    
    private func makeConstraints() {
        self.playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - functions
    
    override func setup<T>(_ item: T) {
        if let video = item as? MWMovieVideo {
            self.playerView.isHidden = false
            self.imageView.isHidden = true
            self.playerView.setup(video)
            self.playerView.playTapped = { [weak self] in
                self?.playerView.thumbnail.isHidden = false
                self?.playerView.player.isHidden = true
                self?.playerView.play()
                return true
            }
        } else if let image = item as? MWMovieImage {
            self.imageView.isHidden = false
            self.playerView.isHidden = true
            image.showImage(size: .w185, in: self.imageView)
        }
    }
}
