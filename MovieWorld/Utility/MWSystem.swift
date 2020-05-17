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

    var genresUrl: String {
        switch self {
        case .movie:
            return URLPaths.movieGenres
        case .tv:
            return URLPaths.tvGenres
        }
    }

    var discoverUrl: String {
        switch self {
        case .movie:
            return URLPaths.discoverMovies
        case .tv:
            return URLPaths.discoverTVs
        }
    }
}

class MWSystem {

    // MARK: - enum

    enum Values {
        case configuration, genres(MWCategory), countries

        static var allCases: [Values] {
            var values: [MWS.Values] = [.configuration, .countries]
            MWCategory.allCases.forEach { values.append(.genres($0)) }
            return values
        }

        func load(completionHandler: (() -> Void)? = nil) {
            switch self {
            case .configuration:
                MWSystem.sh.loadConfiguration(completionHandler: completionHandler)
            case .genres(let category):
                MWSystem.sh.loadGenres(category: category, completionHandler: completionHandler)
            case .countries:
                MWSystem.sh.loadCountries(completionHandler: completionHandler)
            }
        }

        func isNil() -> Bool {
            switch self {
            case .configuration:
                return MWSystem.sh.configuration == nil
            case .genres(let category):
                return MWSystem.sh.genres[category] == nil
                    || MWSystem.sh.genres[category]?.isEmpty ?? true
            case .countries:
                return MWSystem.sh.countries == nil
            }
        }
    }

    // MARK: - variables

    static let sh = MWSystem()

    let animatedMoviesGenreId: Int64 = 16
    private var isNetworkListenerExist = false

    var configuration: MWConfiguration? {
        CDM.sh.loadData(entityName: MWConfiguration.entityName)?.first
    }

    var genres: MWCategories {
        var genres: MWCategories = [:]
        MWCategory.allCases.forEach { category in
            let predicate = NSPredicate(format: "category = %@", category.rawValue)
            genres[category] = CDM.sh.loadData(entityName: MWGenre.entityName,
                                               keysForSort: ["name"],
                                               predicate: predicate)
        }
        return genres
    }

    var countries: [MWCountry]? { CDM.sh.loadData(entityName: MWCountry.entityName) }

    var allUniqueGenres: [MWGenre] {
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

    private func loadConfiguration(completionHandler: (() -> Void)?) {
        MWN.sh.request(
            url: URLPaths.configuration,
            successHandler: { (response: MWConfiguration) in
                CDM.sh.saveContext()
                completionHandler?()
            },
            errorHandler: { [weak self] (error) in
                error.printInConsole()
                self?.startNetworkListener()
                completionHandler?()
        })
    }

    private func loadGenres(category: MWCategory, completionHandler: (() -> Void)?) {
            MWN.sh.request(
                url: category.genresUrl,
                successHandler: { (response: [String: [MWGenre]]) in
                    response["genres"]?.forEach { $0.category = category.rawValue }
                    CDM.sh.saveContext()
                    completionHandler?()
            },
                errorHandler: { [weak self] (error) in
                    error.printInConsole()
                    self?.startNetworkListener()
                    completionHandler?()
            })
    }

    private func loadCountries(completionHandler: (() -> Void)?) {
        MWN.sh.request(
            url: URLPaths.countries,
            successHandler: { (response: [MWCountry]) in
                CDM.sh.saveContext()
                completionHandler?()
            },
            errorHandler: { [weak self] (error) in
                error.printInConsole()
                self?.startNetworkListener()
                completionHandler?()
        })
    }

    private func startNetworkListener() {
        guard !self.isNetworkListenerExist else { return }
        self.isNetworkListenerExist = true
        MWN.sh.networkReachabilityManager?.startListening { [weak self] status in
            if status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi) {
                Values.allCases.forEach { $0.load() }
                MWN.sh.networkReachabilityManager?.stopListening()
                self?.isNetworkListenerExist = false
            }
        }
    }
}
