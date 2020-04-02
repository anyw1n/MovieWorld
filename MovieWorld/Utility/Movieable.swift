//
//  Movieable.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/31/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Kingfisher

protocol Movieable: Decodable {
    
    var title: String? { get }
    var id: Int? { get }
    var genreIDs: [Int]? { get }
    var releaseDate: String? { get }
    var posterPath: String? { get }
    
    var releaseYear: String { get }
    var genres: [String] { get }
    var detailsLoaded: (() -> Void)? { get set }
    
    func showImage(size: Sizes, in imageView: UIImageView)
}

extension Movieable {
    func showImage(size: Sizes, in imageView: UIImageView) {
        guard let posterPath = self.posterPath,
            let baseURL = MWS.sh.configuration?.secureBaseURL else {
                imageView.image = UIImage(named: "noImage")
                return
        }
        
        let url = URL(string: baseURL + size.rawValue + posterPath)
        var options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage]
        if imageView.bounds.size != CGSize.zero {
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            options.append(.processor(processor))
        }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              options: options)
    }
}
