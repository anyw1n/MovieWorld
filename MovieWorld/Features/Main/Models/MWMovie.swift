//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

enum MoviesCodingKeys: String, CodingKey {
    case title, id, genre_ids, release_date
}

struct MWMovie: Decodable {
    
    var title: String
    var id: Int
    var genre_ids: [Int]
    var release_date: String
    var image: UIImage
    var genres: [String] {
        var genres: [String] = []
        self.genre_ids.forEach { (id) in
            genres.append(Genres.movies[id] ?? "NaN")
        }
        return genres
    }
    var releaseYear: String {
        return String(self.release_date.split(separator: "-").first ?? "NaN")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoviesCodingKeys.self)
        self.title =
            (try? container.decode(String.self, forKey: .title)) ?? "NaN"
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.release_date =
            (try? container.decode(String.self, forKey: .release_date)) ?? "NaN"
        self.image = UIImage(named: "bookImage") ?? UIImage()
        self.genre_ids = (try? container.decode([Int].self, forKey: .genre_ids)) ?? []
    }
}
