//
//  Movieable.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/31/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Kingfisher

enum AppendToResponse: String {
    case credits, images, videos
}

protocol Movieable: Decodable {
    
    var title: String { get }
    var id: Int { get }
    var genreIds: [Int] { get }
    var releaseDate: String { get }
    var posterPath: String? { get }
    var overview: String { get }
    var details: Detailable? { get set }
    
    var releaseYear: String { get }
    var genres: [String] { get }
    var detailsLoaded: (() -> Void)? { get set }
    
    func showImage(size: Sizes, in imageView: UIImageView)
    func requestDetails(_ appends: [AppendToResponse]?, completionHandler: (() -> Void)?)
}

extension Movieable {
    func showImage(size: Sizes, in imageView: UIImageView) {
        guard let posterPath = self.posterPath,
            let baseUrl = MWS.sh.configuration?.secureBaseUrl else {
                imageView.image = UIImage(named: "noImage")
                return
        }
        
        let url = URL(string: baseUrl + size.rawValue + posterPath)
        let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage]
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              options: options)
    }
}
