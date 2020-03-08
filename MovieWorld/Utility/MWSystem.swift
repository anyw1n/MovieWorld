//
//  MWSystem.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

typealias MWS = MWSystem

class MWSystem {
    
    //MARK: - variables
    
    static let sh = MWSystem()
    
    var configuration: MWConfiguration?
    var genres: MWCategories?
}
