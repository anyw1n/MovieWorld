//
//  YoutubeDataVideoList.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/12/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class YoutubeDataVideoList<T: YoutubeDataVideo>: Decodable {

    static var path: String { "/videos?" }

    let items: [T]
}
