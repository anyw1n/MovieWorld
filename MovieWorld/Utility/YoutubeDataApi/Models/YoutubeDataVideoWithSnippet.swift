//
//  YoutubeDataVideoWithSnippet.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class YoutubeDataVideoSnippet: YoutubeDataVideo {
    
    struct Snippet: Decodable {
        
        let thumbnails: VideoThumbnails
    }

    static var part: String { "snippet" }
    
    let snippet: Snippet
}

struct VideoThumbnails: Decodable {
    
    struct Values: Decodable {
        let url: String?
        let height: Int?
        let width: Int?
    }
    
    let `default`: Values
    let medium: Values
    let high: Values
    let standard: Values
    let maxres: Values
}
