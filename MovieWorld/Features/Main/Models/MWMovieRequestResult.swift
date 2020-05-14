//
//  MWMovieRequestResult.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/28/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWMovieRequestResult: Decodable {

    // MARK: - enum

    private enum CodingKeys: String, CodingKey {
        case page, results, totalResults = "total_results", totalPages = "total_pages"
    }

    // MARK: - variables

    let page: Int?
    let results: [MWMovie]?
    let totalResults: Int?
    let totalPages: Int?
}
