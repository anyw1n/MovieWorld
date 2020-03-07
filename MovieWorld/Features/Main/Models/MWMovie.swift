//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

enum MoviesCodingKeys: String, CodingKey {
    case title, id, genreIDs = "genre_ids", releaseDate = "release_date"
}

struct MWMovie: Decodable {
    
    var title: String
    var id: Int
    var genreIDs: [Int]
    var releaseDate: String
    var image: UIImage
    
    var releaseYear: String {
        return String(self.releaseDate.split(separator: "-").first ?? "NaN")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoviesCodingKeys.self)
        self.title =
            (try? container.decode(String.self, forKey: .title)) ?? "NaN"
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.releaseDate =
            (try? container.decode(String.self, forKey: .releaseDate)) ?? "NaN"
        self.image = UIImage(named: "bookImage") ?? UIImage()
        self.genreIDs = (try? container.decode([Int].self, forKey: .genreIDs)) ?? []
    }
}
