//
//  YoutubeDataVideoWithPlayer.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class YoutubeDataVideoPlayer: YoutubeDataVideo {
    
    struct Player: Decodable {
        let embedHtml: String
        let embedHeight: String?
        let embedWidth: String?
    }

    static var part: String { "player" }
    
    let player: Player
}
