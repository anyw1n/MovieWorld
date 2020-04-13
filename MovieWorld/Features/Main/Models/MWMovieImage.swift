//
//  MWMovieImage.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Kingfisher

struct MWMovieImage: Mediable {
    
    private enum CodingKeys: String, CodingKey {
        case filePath = "file_path", aspectRatio = "aspect_ratio"
    }
    
    let filePath: String
    let aspectRatio: CGFloat
    
    func showImage(size: Sizes, in imageView: UIImageView) {
        guard let baseUrl = MWS.sh.configuration?.secureBaseUrl else {
            imageView.image = UIImage(named: "noImage")
            return
        }
        
        let url = URL(string: baseUrl + size.rawValue + self.filePath)
        let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage]
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              options: options)
    }
    
    func calculateWidth(height: CGFloat) -> CGFloat {
        return self.aspectRatio * height
    }
}
