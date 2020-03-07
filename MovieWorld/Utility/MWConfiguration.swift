//
//  MWConfiguration.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/7/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation
import Alamofire

enum Sizes: String {
    case w45, w92, w154, w185, w300, w342, w500, w780, w1280, original
}

typealias MWC = MWConfiguration

struct MWConfiguration {

    static let sh = MWConfiguration()
    
    let baseURL = "https://image.tmdb.org/t/p/"
    
    private init() {}
    
    func getImage(size: Sizes,
                  imagePath: String,
                  handler: @escaping (UIImage?) -> Void) {
        let url = self.baseURL + size.rawValue + imagePath
        
        AF.request(url).responseData(completionHandler: { (response) in
            guard let data = response.data else { return }
            handler(UIImage(data: data))
        })
    }
}
