//
//  Detailable.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/6/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

protocol Detailable: Decodable {
    
    var runtime: Int? { get }
    var countryNames: [String] { get }
    var credits: MWCredits? { get set }
    var videos: [MWMovieVideo]? { get set }
    var images: MWImages? { get set }
}

struct MWImages: Decodable {
    let backdrops: [MWMovieImage]
    let posters: [MWMovieImage]
}
