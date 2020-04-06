//
//  MWShowDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/2/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWShowDetails: Detailable {
    
    private enum CodingKeys: String, CodingKey {
        case originCountryCodes = "origin_country", lastAirDate = "last_air_date",
        episodeRuntime = "episode_run_time", credits
    }
    
    // MARK: - variables
    
    let originCountryCodes: [String]
    let lastAirDate: String
    let episodeRuntime: [Int]
    var credits: MWMovieCredits?
    
    var lastAirYear: String { String(self.lastAirDate.split(separator: "-").first ?? "") }
    var runtime: Int? { self.episodeRuntime.first }

    var originCountries: [MWCountry] {
        var countries: [MWCountry] = []
        self.originCountryCodes.forEach { (code) in
            if let country = MWS.sh.countries?.first(where: { $0.isoCode == code }) {
                countries.append(country)
            }
        }
        return countries
    }
    
    var countryNames: [String] {
        var names: [String] = []
        self.originCountries.forEach { names.append($0.name ?? "") }
        return names
    }
    
}
