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
}

class MWSystem {
    
    // MARK: - variables
    
    static let sh = MWSystem()
    
    var configuration: MWConfiguration?
    var genres: MWCategories = [:]
    var countries: [MWCountry]?
    var allGenres: [MWGenre] {
        var genres: [MWGenre] = []
        self.genres.forEach { genres.append(contentsOf: $0.value) }
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
