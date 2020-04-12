//
//  YoutubeDataVideo.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

protocol YoutubeDataVideo: Decodable {
    
    static var part: String { get }
}
