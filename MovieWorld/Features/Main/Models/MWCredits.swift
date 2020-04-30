//
//  MWCredits.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/22/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

struct MWCredits: Decodable {

    // MARK: - variables

    let cast: [MWActor]
    let crew: [MWCreator]

    // MARK: - functions

    func getCreators(with job: String) -> [MWCreator] {
        return self.crew.filter { $0.job == job }
    }
}
