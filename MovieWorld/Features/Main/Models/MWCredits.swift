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
    var creators: [(name: String, creators: [MWCreator])] {
        var creators: [(String, [MWCreator])] = []
        creators.append(("Director".localized(), self.getCreators(with: "Director")))
        creators.append(("Scenario".localized(), self.getCreators(with: "Screenplay")))
        creators.append(("Producers".localized(), self.getCreators(with: "Producer")))
        return creators
    }
    
    // MARK: - functions
    
    private func getCreators(with job: String) -> [MWCreator] {
        return self.crew.filter { $0.job == job }
    }
}
