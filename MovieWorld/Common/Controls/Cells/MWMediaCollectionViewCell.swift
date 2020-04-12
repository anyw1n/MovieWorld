//
//  MWMediaCollectionViewCell.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMediaCollectionViewCell: UICollectionViewCell {
    
    // MARK: - variables
    
    static let reuseId = "mediaCollectionViewCell"
    var isWidthCalculated: Bool = false
    
    // MARK: - gui variables
    
    private lazy var playerView: MWPlayer = {
        let player = MWPlayer()
        player.defaultPlayerParameters["playsinline"] = 0
        player.defaultPlayerParameters["controls"] = 0
        player.layer.cornerRadius = 5
        player.clipsToBounds = true
        player.isHidden = true
        return player
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.playerView)
        self.addSubview(self.imageView)
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
    
    func setup(_ item: Mediable) {
        if let video = item as? MWMovieVideo {
            self.playerView.isHidden = false
            self.imageView.isHidden = true
            self.playerView.setup(video)
            self.playerView.playTapped = { [weak self] in
                self?.playerView.play()
                return true
            }
        } else if let image = item as? MWMovieImage {
            self.imageView.isHidden = false
            self.playerView.isHidden = true
            image.showImage(size: .w92, in: self.imageView)
        }
    }
}
