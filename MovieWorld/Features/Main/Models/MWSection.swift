//
//  Section.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/14/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation
import Alamofire

class MWSection {

    // MARK: public stored

    let name: String
    let url: String?
    let category: MWCategory?
    let isStaticSection: Bool
    var genreIds: Set<Int64>?
    var movies: [Movieable]
    var pagesLoaded: Int = 0
    var totalPages: Int = 1
    var totalResults: Int = 0
    var message: String = "Nothing to show here..".localized()

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
    private var currentRequest: DataRequest? {
        willSet {
            self.currentRequest?.cancel()
        }
    }

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

    func copy() -> MWSection {
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

    func clear() {
        self.pagesLoaded = 0
        self.movies = []
        self.totalResults = 0
        self.totalPages = 1
    }

    // MARK: - loaders

    func loadMovies(completionHandler: (() -> Void)?,
                    errorHandler: ((MWNetError) -> Void)?) {
        guard !self.isStaticSection, let category = self.category else {
            if let originalMovies = self.originalMovies,
                let genreIds = self.genreIds {
                self.movies = originalMovies.filter { (movie) -> Bool in
                    for id in genreIds {
                        if !movie.genreIds.contains(Int(id)) { return false }
                    }
                    return true
                }
            }
            completionHandler?()
            return
        }

        switch category {
        case .movie:
            self.request(completionHandler: { (_: MWMovieRequestResult<MWMovie>) in
                completionHandler?()
            }) { (error) in
                errorHandler?(error)
            }
        case .tv:
            self.request(completionHandler: { (_: MWMovieRequestResult<MWShow>) in
                completionHandler?()
            }) { (error) in
                errorHandler?(error)
            }
        }
    }

    private func loadResults<T: Movieable>(from requestResult: MWMovieRequestResult<T>) {
        self.pagesLoaded = requestResult.page ?? 0
        self.movies.append(contentsOf: requestResult.results ?? [])
        self.totalResults = requestResult.totalResults ?? 0
        self.totalPages = requestResult.totalPages ?? 1
        if self.movies.isEmpty {
            self.message = "Nothing to show here..".localized()
        }
    }

    // MARK: - request

    private func request<T: Movieable>(completionHandler: ((MWMovieRequestResult<T>) -> Void)?,
                                       errorHandler: ((MWNetError) -> Void)?) {
        guard let url = self.url else { return }
        self.requestParameters["page"] = self.pagesLoaded + 1
        self.currentRequest = MWN.sh
            .request(url: url,
                     queryParameters: self.requestParameters,
                     successHandler: { (response: MWMovieRequestResult<T>) in
                        self.loadResults(from: response)
                        completionHandler?(response)
            },
                     errorHandler: { (error) in
                        error.printInConsole()
                        self.message = error.getDescription()
                        errorHandler?(error)
            })
    }
}
