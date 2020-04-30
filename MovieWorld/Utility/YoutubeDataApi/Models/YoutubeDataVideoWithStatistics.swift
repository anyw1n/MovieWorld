//
//  YoutubeDataVideoWithStatistics.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class YoutubeDataVideoStatistics: YoutubeDataVideo {

    struct Statistics: Decodable {
        let dislikeCount: String
        let likeCount: String
    }

    static var part: String { "statistics" }

    let statistics: Statistics
}
