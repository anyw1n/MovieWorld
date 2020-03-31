//
//  MWShow.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/31/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWShow: Movieable {
    
    private enum CodingKeys: String, CodingKey {
        case name, id, genreIDs = "genre_ids", firstAirDate = "first_air_date",
        posterPath = "poster_path"
    }
    
    //MARK: - variables

    let name: String?
    let id: Int?
    let genreIDs: [Int]?
    let firstAirDate: String?
    let posterPath: String?
    
    var firstAirYear: String {
        return String(self.firstAirDate?.split(separator: "-").first ?? "")
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
    
    var title: String? { self.name }
    var releaseDate: String? { self.firstAirDate }
    var releaseYear: String { self.firstAirYear }
}
