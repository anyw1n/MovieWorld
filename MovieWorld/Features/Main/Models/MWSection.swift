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
    var genreIds: Set<Int64>?
    var movies: [MWMovie] = []
    var requestParameters: [String: Any] {
        get {
            var parameters = self._requestParameters
            parameters["with_genres"] = (genreIds?.map { String($0) })?.joined(separator: ",")
            return parameters
        }
        set {
            self._requestParameters = newValue
        }
    }
    private var _requestParameters: [String: Any]
    
    init(name: String, url: String, parameters: [String: Any] = [:], genreIds: Set<Int64>? = nil) {
        self.name = name
        self.url = url
        self._requestParameters = parameters
        self.genreIds = genreIds
    }
}
