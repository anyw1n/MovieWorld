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
        episodeRuntime = "episode_run_time", credits, videos, images
    }
    
    private enum VideoCodingKeys: String, CodingKey {
        case results
    }
    
    // MARK: - variables
    
    let originCountryCodes: [String]
    let lastAirDate: String
    let episodeRuntime: [Int]
    var credits: MWCredits?
    var videos: [MWMovieVideo]?
    var images: MWImages?

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
    
    // MARK: - init
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originCountryCodes =
            (try? container.decode([String].self, forKey: .originCountryCodes)) ?? []
        self.lastAirDate = (try? container.decode(String.self, forKey: .lastAirDate)) ?? ""
        self.episodeRuntime = (try? container.decode([Int].self, forKey: .episodeRuntime)) ?? []
        self.credits = try? container.decode(MWCredits.self, forKey: .credits)
        self.images = try? container.decode(MWImages.self, forKey: .images)
        if container.contains(.videos) {
            let videoContainer =
                try container.nestedContainer(keyedBy: VideoCodingKeys.self, forKey: .videos)
            self.videos = try? videoContainer.decode([MWMovieVideo].self, forKey: .results)
        }
    }
}
