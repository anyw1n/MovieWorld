//
//  MWImageSizes.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

enum Sizes: String, Decodable {
    case w45, w92, w154, w185, w300, w342, w500, w780, w1280, h632, original, unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try (Sizes(rawValue: (container.decode(RawValue.self))) ?? .unknown)
    }
}
