//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

struct MWMovie {
    
    var title: String
    var description: String
    var image: UIImage
    
    init(title: String,
         description: String,
         image: UIImage = UIImage(named: "bookImage") ?? UIImage()) {
        self.title = title
        self.description = description
        self.image = image
    }
}
