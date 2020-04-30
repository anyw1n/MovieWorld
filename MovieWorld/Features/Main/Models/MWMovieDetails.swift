//
//  MWMovieDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/2/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWMovieDetails: Detailable {

    private enum CodingKeys: String, CodingKey {
        case productionCountries = "production_countries", runtime, credits, videos, images
    }

    private enum VideoCodingKeys: String, CodingKey {
        case results
    }

    // MARK: - variables

    let productionCountries: [MWCountry]
    let runtime: Int?
    var credits: MWCredits?
    var videos: [MWMovieVideo]?
    var images: MWImages?

    var countryNames: [String] {
        var names: [String] = []
        self.productionCountries.forEach { names.append($0.name ?? "") }
        return names
    }

    // MARK: - init

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productionCountries =
            (try? container.decode([MWCountry].self, forKey: .productionCountries)) ?? []
        self.runtime = try? container.decode(Int.self, forKey: .runtime)
        self.credits = try? container.decode(MWCredits.self, forKey: .credits)
        self.images = try? container.decode(MWImages.self, forKey: .images)
        if container.contains(.videos) {
            let videoContainer =
                try container.nestedContainer(keyedBy: VideoCodingKeys.self, forKey: .videos)
            self.videos = try? videoContainer.decode([MWMovieVideo].self, forKey: .results)
        }
    }
}
