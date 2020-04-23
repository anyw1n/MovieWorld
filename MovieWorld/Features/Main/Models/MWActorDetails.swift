//
//  MWActorDetails.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/23/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

class MWActorDetails: Decodable {
    let birthday: String?
    let deathday: String?
    let biography: String
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
}
