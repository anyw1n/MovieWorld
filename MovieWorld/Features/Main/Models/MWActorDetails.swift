//
//  MWActorDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/23/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWActorDetails: Decodable {

    private enum CodingKeys: String, CodingKey {
        case birthday, deathday, biography, movieCredits = "movie_credits", tvCredits = "tv_credits"
    }

    // MARK: - variables

    let birthday: String?
    let deathday: String?
    let biography: String
    var movieCredits: MWActorCredits<MWMovie>?
    var tvCredits: MWActorCredits<MWShow>?
    var birthDate: Date? {
        guard let birthday = self.birthday else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: birthday)
    }
    var deathDate: Date? {
        guard let deathday = self.deathday else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: deathday)
    }
    var jobs: Set<String>? {
        guard let movies = self.movieCredits?.crew,
            let tv = self.tvCredits?.crew else { return nil }
        var jobs: Set<String> = []
        movies.forEach { jobs.insert($0.job) }
        tv.forEach { jobs.insert($0.job) }
        if jobs.isEmpty {
            return nil
        }
        return jobs
    }
}

struct MWActorCredits<T: Movieable>: Decodable {

    struct Jobs: Decodable {
        let job: String
    }

    var cast: [T]
    var crew: [Jobs]
}
