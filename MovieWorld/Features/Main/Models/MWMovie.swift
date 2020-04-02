//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovie: Movieable {
    
    private enum CodingKeys: String, CodingKey {
        case title, id, genreIDs = "genre_ids", releaseDate = "release_date",
        posterPath = "poster_path"
    }
    
    //MARK: - variables

    let title: String?
    let id: Int?
    let genreIDs: [Int]?
    let releaseDate: String?
    let posterPath: String?

    var releaseYear: String {
        return String(self.releaseDate?.split(separator: "-").first ?? "")
    }
    var genres: [String] {
        var genres: [String] = []
        self.genreIDs?.forEach {
            genres.append(MWS.sh.getGenreBy(id: $0)?.name ?? "No genre".localized())
        }
        if genres.isEmpty {
            genres.append("No genre".localized())
        }
        return genres
    }
    
    var details: MWMovieDetails?
    
    //MARK: - init
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title))
        self.id = (try? container.decode(Int.self, forKey: .id))
        self.releaseDate = (try? container.decode(String.self, forKey: .releaseDate))
        self.genreIDs = (try? container.decode([Int].self, forKey: .genreIDs))
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
        self.requestDetails()
    }
    
    //MARK: - functions
    
    func requestDetails() {
        guard let id = self.id, self.details == nil else { return }
        
        let url = URLPaths.movieDetails + String(id)
        MWN.sh.request(url: url,
                       successHandler: { [weak self] (response: MWMovieDetails) in
                        self?.details = response
        }) { (error) in
            error.printInConsole()
        }
    }
}
