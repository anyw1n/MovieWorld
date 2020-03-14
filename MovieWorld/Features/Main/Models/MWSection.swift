//
//  Section.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWSection {
    let name: String
    let url: String
    let requestParameters: [String: Any]?
    var movies: [MWMovie] = []
    
    init(name: String, url: String, parameters: [String: Any]? = nil) {
        self.name = name
        self.url = url
        self.requestParameters = parameters
    }
}
