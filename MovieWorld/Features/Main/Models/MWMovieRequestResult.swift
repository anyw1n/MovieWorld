//
//  MWMovieRequestResult.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/28/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

struct MWMovieRequestResult<T: Movieable>: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case page, results, totalResults = "total_results", totalPages = "total_pages"
    }
    
    let page: Int?
    let results: [T]?
    let totalResults: Int?
    let totalPages: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = (try? container.decode(Int.self, forKey: .page))
        self.results = (try? container.decode([T].self, forKey: .results))
        self.totalResults = (try? container.decode(Int.self, forKey: .totalResults))
        self.totalPages = (try? container.decode(Int.self, forKey: .totalPages))
    }
}
