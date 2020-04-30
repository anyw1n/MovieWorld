//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWMovie: Movieable {

    // MARK: - enum

    private enum CodingKeys: String, CodingKey {
        case title, id, genreIds = "genre_ids", releaseDate = "release_date",
        posterPath = "poster_path", overview
    }

    // MARK: - variables

    // MARK: public stored

    let title: String
    let id: Int
    let genreIds: [Int]
    let releaseDate: String
    let posterPath: String?
    let overview: String
    var details: Detailable?
    var detailsLoaded: (() -> Void)?

    // MARK: public computed

    var releaseYear: String {
        return String(self.releaseDate.split(separator: "-").first ?? "")
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

    // MARK: - init

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.releaseDate = (try? container.decode(String.self, forKey: .releaseDate)) ?? ""
        self.genreIds = (try? container.decode([Int].self, forKey: .genreIds)) ?? []
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
        self.overview = (try? container.decode(String.self, forKey: .overview)) ?? ""
        self.requestDetails()
    }

    // MARK: - functions

    func requestDetails(_ appends: [MovieAppendToResponse]? = nil,
                        completionHandler: (() -> Void)? = nil) {
        var appendNames: [String] = []
        appends?.forEach { appendNames.append($0.rawValue) }
        let url = URLPaths.movieDetails + String(self.id)
        var imageLanguages = ["null"]
        if let language = Locale.current.languageCode {
            imageLanguages.append(language)
        }
        MWN.sh.request(url: url,
                       queryParameters: ["append_to_response": appendNames.joined(separator: ","),
                                         "include_image_language": imageLanguages.joined(separator: ",")],
                       successHandler: { [weak self] (response: MWMovieDetails) in
                        self?.details = response
                        self?.detailsLoaded?()
                        completionHandler?()
            }, errorHandler: { (error) in
                error.printInConsole()
        })
    }
}
