//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Kingfisher

class MWMovie: Decodable {
    
    //MARK: - enum
    
    private enum CodingKeys: String, CodingKey {
        case title, id, genreIDs = "genre_ids", releaseDate = "release_date",
        posterPath = "poster_path"
    }
    
    //MARK: - variables
    
    //MARK: public stored

    var title: String?
    var id: Int?
    var genreIDs: [Int]?
    var releaseDate: String?
    var posterPath: String?
    
    //MARK: public computed
    
    var releaseYear: String {
        return String(self.releaseDate?.split(separator: "-").first ?? "")
    }
    var genres: [String] {
        var genres: [String] = []
        self.genreIDs?.forEach {
            genres.append(MWS.sh.getGenreBy(id: $0)?.name ?? "No genre".localized())
        }
        if genres.isEmpty {
            genres.append("No genre".localized())
        }
        return genres
    }
    
    //MARK: - init
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title))
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.releaseDate = (try? container.decode(String.self, forKey: .releaseDate))
        self.genreIDs = (try? container.decode([Int].self, forKey: .genreIDs))
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
    }
    
    //MARK: - functions
    
    func showImage(size: Sizes, in imageView: UIImageView) {
        guard let posterPath = self.posterPath,
            let baseURL = MWS.sh.configuration?.secureBaseURL else {
                imageView.image = UIImage(named: "noImage")
                return
        }
        
        let url = URL(string: baseURL + size.rawValue + posterPath)
        var options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .transition(.fade(1)),
                                              .cacheOriginalImage]
        if imageView.bounds.size != CGSize.zero {
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            options.append(.processor(processor))
        }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              options: options)
    }
}
