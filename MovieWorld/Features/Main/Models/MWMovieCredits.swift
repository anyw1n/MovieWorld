//
//  MWMovieCredits.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/5/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWMovieCredits: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case cast
    }
    
    // MARK: - variables

    let cast: [MWActor]
}
