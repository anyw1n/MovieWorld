//
//  MWMovieVideo.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/7/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation
import Kingfisher

struct MWMovieVideo: Decodable {
    
    // MARK: - variables
    
    let key: String
    let name: String
    let site: String
    
    // MARK: - functions
    
    func showThumbnail(in imageView: UIImageView) {
        self.requestThumbnailUrl { (url) in
            let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                                  .transition(.fade(1)),
                                                  .cacheOriginalImage]

            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url,
                                  options: options)
        }
    }
    
    private func requestThumbnailUrl(successHandler: @escaping (URL) -> Void) {
        YTApi.sh.request(videoId: self.key) { (response: YoutubeDataVideoSnippet) in
            if let stringUrl = response.snippet.thumbnails.high.url,
                let url = URL(string: stringUrl) {
                successHandler(url)
            }
        }
    }
}
