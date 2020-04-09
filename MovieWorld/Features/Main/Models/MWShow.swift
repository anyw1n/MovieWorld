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
        case name, id, genreIds = "genre_ids", firstAirDate = "first_air_date",
        posterPath = "poster_path", overview
    }
    
    // MARK: - variables

    let name: String
    let id: Int
    let genreIds: [Int]
    let firstAirDate: String
    let posterPath: String?
    let overview: String
    
    var firstAirYear: String {
        return String(self.firstAirDate.split(separator: "-").first ?? "")
    }
    var genres: [String] {
        var genres: [String] = []
        self.genreIds.forEach {
            genres.append(MWS.sh.getGenreBy(id: $0)?.name ?? "No genre".localized())
        }
        if genres.isEmpty {
            genres.append("No genre".localized())
        }
        return genres
    }
    
    var title: String { self.name }
    var releaseDate: String { self.firstAirDate }
    var releaseYear: String {
        if let details = self.details as? MWShowDetails,
            self.firstAirYear != details.lastAirYear {
            return "\(self.firstAirYear) - \(details.lastAirYear)"
        }
        return self.firstAirYear
    }
    
    var details: Detailable?
    var detailsLoaded: (() -> Void)?
    
    // MARK: - init
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.firstAirDate = (try? container.decode(String.self, forKey: .firstAirDate)) ?? ""
        self.genreIds = (try? container.decode([Int].self, forKey: .genreIds)) ?? []
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
        self.overview = (try? container.decode(String.self, forKey: .overview)) ?? ""
        self.requestDetails()
    }
    
    // MARK: - functions
    
    func requestDetails(_ appends: [AppendToResponse]? = nil,
                        completionHandler: (() -> Void)? = nil) {
        var appendNames: [String] = []
        appends?.forEach { appendNames.append($0.rawValue) }
        let url = URLPaths.tvDetails + String(self.id)
        MWN.sh.request(url: url,
                       queryParameters: ["append_to_response": appendNames.joined(separator: ",")],
                       successHandler: { [weak self] (response: MWShowDetails) in
                        self?.details = response
                        self?.detailsLoaded?()
                        completionHandler?()
            }, errorHandler: { (error) in
                error.printInConsole()
        })
    }
}
