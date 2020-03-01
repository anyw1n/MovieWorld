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
    
    private init() {
        self.title = ""
        self.description = ""
        self.image = UIImage(named: "bookImage") ?? UIImage()
    }
    
    static func parse(movieId: String) -> MWMovie {
        var movie = MWMovie()
        MWN.sh.request(typeOfResult: [String: Any].self,
                       url: "/movie/" + movieId, successHandler: { (result) in
            movie.title = result["title"] as? String ?? ""
            movie.description = String((result["release_date"] as? String)?.split(separator: "-").first ?? "")
            //movie.image = UIImage(named: "bookImage") ?? UIImage()
        }) { (error) in
            
        }
        
        return movie
    }
}
