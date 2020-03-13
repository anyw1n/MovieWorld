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
    
    //MARK: - variables
    
    static let sh = MWSystem()
    
    var configuration: MWConfiguration?
    var genres: MWCategories = [:]
    
    //MARK: - init
    
    private init() {}
    
    //MARK: - functions
    
    func getGenreBy(id: Int, in category: MWCategory) -> MWGenre? {
        return self.genres[category]?.first { $0.id == id }
    }
}
