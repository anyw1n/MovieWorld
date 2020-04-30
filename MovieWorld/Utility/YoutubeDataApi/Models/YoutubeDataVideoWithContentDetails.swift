//
//  YoutubeDataVideoWithContentDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class YoutubeDataVideoContentDetails: YoutubeDataVideo {

    struct ContentDetails: Decodable {
        let definition: String
    }

    static var part: String { "contentDetails" }

    let contentDetails: ContentDetails
}
