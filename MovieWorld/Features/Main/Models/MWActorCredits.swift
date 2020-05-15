//
//  MWActorCredits.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 5/15/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

struct MWActorCredits<T: Movieable>: Decodable {

    struct Jobs: Decodable {
        let job: String
    }

    var cast: [T]
    var crew: [Jobs]
}
