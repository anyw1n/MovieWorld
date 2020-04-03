//
//  MWShowDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/2/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWShowDetails: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case originCountryCodes = "origin_country"
    }
    
    // MARK: - variables
    
    let originCountryCodes: [String]
    
    var originCountries: [MWCountry] {
        var countries: [MWCountry] = []
        self.originCountryCodes.forEach { (code) in
            if let country = MWS.sh.countries?.first(where: { $0.isoCode == code }) {
                countries.append(country)
            }
        }
        return countries
    }
    
    var originCountryNames: [String] {
        var names: [String] = []
        self.originCountries.forEach { names.append($0.name ?? "") }
        return names
    }
    
}
