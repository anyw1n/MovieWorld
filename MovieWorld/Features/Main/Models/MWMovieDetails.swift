//
//  MWMovieDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/2/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWMovieDetails: Decodable {
        
    private enum CodingKeys: String, CodingKey {
        case productionCountries = "production_countries"
    }
    
    //MARK: - variables

    let productionCountries: [MWCountry]
    
    var productionCountryNames: [String] {
        var names: [String] = []
        self.productionCountries.forEach { names.append($0.name ?? "") }
        return names
    }
}
