//
//  Section.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWSection: NSCopying {

    // MARK: - variables

    // MARK: public stored

    let name: String
    let url: String?
    let category: MWCategory?
    let isStaticSection: Bool
    var genreIds: Set<Int64>?
    var movies: [Movieable]
    var pagesLoaded: Int = 0
    var totalPages: Int = -1
    var totalResults: Int = -1

    // MARK: public computed

    var requestParameters: [String: Any] {
        get {
            var parameters = self._requestParameters
            parameters["with_genres"] = (genreIds?.map { String($0) })?.joined(separator: ",")
            return parameters
        }
        set {
            self._requestParameters = newValue
        }
    }
    var originalMovies: [Movieable]? { self._originalMovies }

    // MARK: private stored

    private var _requestParameters: [String: Any]
    private var _originalMovies: [Movieable]?

    // MARK: - init

    init(name: String,
         url: String? = nil,
         category: MWCategory? = nil,
         parameters: [String: Any] = [:],
         genreIds: Set<Int64>? = nil,
         movies: [Movieable] = [],
         isStaticSection: Bool = false) {
        self.name = name
        self.url = url
        self.category = category
        self._requestParameters = parameters
        self.genreIds = genreIds
        self.movies = movies
        self.isStaticSection = isStaticSection
        if isStaticSection {
            self._originalMovies = movies
        }
    }

    // MARK: - functions

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MWSection(name: self.name,
                             url: self.url,
                             category: self.category,
                             parameters: self._requestParameters,
                             genreIds: self.genreIds,
                             movies: self.movies,
                             isStaticSection: self.isStaticSection)
        copy.pagesLoaded = self.pagesLoaded
        copy.totalPages = self.totalPages
        copy.totalResults = self.totalResults
        return copy
    }

    func loadResults<T: Movieable>(from requestResult: MWMovieRequestResult<T>) {
        self.pagesLoaded = requestResult.page ?? 0
        self.movies.append(contentsOf: requestResult.results ?? [])
        self.totalResults = requestResult.totalResults ?? 0
        self.totalPages = requestResult.totalPages ?? 0
    }

    func clearResults() {
        self.pagesLoaded = 0
        self.movies = []
        self.totalResults = -1
        self.totalPages = -1
    }
}
