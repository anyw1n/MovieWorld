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
    
    var details: MWShowDetails?
    var detailsLoaded: (() -> Void)?
    
    //MARK: - init
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name))
        self.id = (try? container.decode(Int.self, forKey: .id))
        self.firstAirDate = (try? container.decode(String.self, forKey: .firstAirDate))
        self.genreIDs = (try? container.decode([Int].self, forKey: .genreIDs))
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
        self.requestDetails()
    }
    
    //MARK: - functions
    
    func requestDetails() {
        guard let id = self.id, self.details == nil else { return }
        
        let url = URLPaths.tvDetails + String(id)
        MWN.sh.request(url: url,
                       successHandler: { [weak self] (response: MWShowDetails) in
                        self?.details = response
                        self?.detailsLoaded?()
        }) { (error) in
            error.printInConsole()
        }
    }
}
