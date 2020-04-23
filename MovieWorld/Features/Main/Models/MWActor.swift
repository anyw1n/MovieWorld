//
//  MWActor.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/5/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Kingfisher

class MWActor: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case character, name, profilePath = "profile_path", id
    }
    
    // MARK: - variables

    let character: String
    let name: String
    let profilePath: String?
    let id: Int
    var details: MWActorDetails?
    var detailsLoaded: (() -> Void)?
    
    // MARK: - functions
    
    func showProfileImage(size: Sizes, in imageView: UIImageView) {
        guard let profilePath = self.profilePath,
            let baseUrl = MWS.sh.configuration?.secureBaseUrl else {
                imageView.image = UIImage(named: "noImage")
                return
        }
        
        let url = URL(string: baseUrl + size.rawValue + profilePath)
        let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage]
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              options: options)
    }
    
    func requestDetails() {
        let url = URLPaths.person + String(self.id)
        MWN.sh.request(url: url,
                       successHandler: { [weak self] (response: MWActorDetails) in
                        self?.details = response
                        self?.detailsLoaded?()
            }, errorHandler: { (error) in
                error.printInConsole()
        })
    }
}
