//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

enum MoviesCodingKeys: String, CodingKey {
    case title, id, genreIDs = "genre_ids", releaseDate = "release_date", posterPath = "poster_path"
}

class MWMovie: Decodable {
    
    var title: String?
    var id: Int
    var genreIDs: [Int]?
    var releaseDate: String?
    var posterPath: String?
    var image: UIImage?
    
    var releaseYear: String {
        return String(self.releaseDate?.split(separator: "-").first ?? "")
    }
    var genres: [String] {
        var genres: [String] = []
        self.genreIDs?.forEach({ (id) in
            genres.append(Genres.movie[id] ?? "no genre")
        })
        return genres
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoviesCodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title))
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.releaseDate = (try? container.decode(String.self, forKey: .releaseDate))
        self.genreIDs = (try? container.decode([Int].self, forKey: .genreIDs))
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
        
        if let posterPath = self.posterPath {
            MWC.sh.getImage(size: .w154,
                            imagePath: posterPath,
                            handler: { [weak self] (image) in
                                self?.image = image
            })
        }
    }
}
