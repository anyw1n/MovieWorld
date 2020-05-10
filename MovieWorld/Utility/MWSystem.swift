//
//  MWSystem.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

typealias MWS = MWSystem
typealias MWCategories = [MWCategory: [MWGenre]]

enum MWCategory: String, CaseIterable {
    case movie, tv

    var url: String {
        switch self {
        case .movie:
            return URLPaths.movieGenres
        case .tv:
            return URLPaths.tvGenres
        }
    }
}

class MWSystem {

    // MARK: - variables

    static let sh = MWSystem()

    let animatedMoviesGenreId: Int64 = 16

    lazy var configuration: MWConfiguration? =
        CDM.sh.loadData(entityName: MWConfiguration.entityName)?.first
    lazy var genres: MWCategories = {
        var genres: MWCategories = [:]
        MWCategory.allCases.forEach { category in
            let predicate = NSPredicate(format: "category = %@", category.rawValue)
            genres[category] = CDM.sh.loadData(entityName: MWGenre.entityName,
                                               keysForSort: ["name"],
                                               predicate: predicate)
        }
        return genres
    }()
    lazy var countries: [MWCountry]? = CDM.sh.loadData(entityName: MWCountry.entityName)

    var allGenres: [MWGenre] {
        var genres: [MWGenre] = []
        for category in MWCategory.allCases {
            guard let values = self.genres[category] else { continue }
            for genre in values {
                if !genres.contains(where: { $0.id == genre.id && $0.name == genre.name }) {
                    genres.append(genre)
                }
            }
        }
        return genres
    }

    // MARK: - init

    private init() {}

    // MARK: - functions

    func getGenreBy(id: Int) -> MWGenre? {
        for genres in self.genres.values {
            if let genre = genres.first(where: { $0.id == id }) {
                return genre
            }
        }
        return nil
    }
}
