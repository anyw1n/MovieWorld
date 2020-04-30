//
//  MWMovieVideo.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/7/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation
import Kingfisher

struct MWMovieVideo: Mediable {

    enum Size {
        case `default`, medium, high, standard
    }

    // MARK: - variables

    let key: String
    let name: String
    let site: String

    // MARK: - functions

    func showThumbnail(size: Size, in imageView: UIImageView) {
        self.requestThumbnailUrl(size: size) { (url) in
            let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                                  .transition(.fade(1)),
                                                  .cacheOriginalImage]

            imageView.kf.setImage(with: url,
                                  options: options)
        }
    }

    private func requestThumbnailUrl(size: Size, successHandler: @escaping (URL) -> Void) {
        YTApi.sh.request(videoId: self.key) { (response: YoutubeDataVideoSnippet) in
            var value = response.snippet.thumbnails.default
            switch size {
            case .default:
                break
            case .medium:
                value = response.snippet.thumbnails.medium
            case .high:
                value = response.snippet.thumbnails.high
            case .standard:
                value = response.snippet.thumbnails.standard
            }
            if let stringUrl = value.url,
                let url = URL(string: stringUrl) {
                successHandler(url)
            }
        }
    }
}
