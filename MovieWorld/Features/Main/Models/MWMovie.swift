//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 2/25/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit



class MWMovie: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case title, id, genreIDs = "genre_ids", releaseDate = "release_date",
        posterPath = "poster_path"
    }
    
    //MARK: - variables

    var title: String?
    var id: Int
    var genreIDs: [Int]?
    var releaseDate: String?
    var posterPath: String?
    var image: UIImage?
    
    var releaseYear: String {
        return String(self.releaseDate?.split(separator: "-").first ?? "")
    }
    var genres: [String] {
        var genres: [String] = []
        self.genreIDs?.forEach {
            genres.append(MWS.sh.getGenreBy(id: $0, in: .movie)?.name ?? "No genre".localized())
        }
        if genres.isEmpty {
            genres.append("No genre".localized())
        }
        return genres
    }
    var imageLoaded: ((Int) -> Void)?
    
    //MARK: - init
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container.decode(String.self, forKey: .title))
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        self.releaseDate = (try? container.decode(String.self, forKey: .releaseDate))
        self.genreIDs = (try? container.decode([Int].self, forKey: .genreIDs))
        self.posterPath = (try? container.decode(String.self, forKey: .posterPath))
        
        self.loadImage()
    }
    
    //MARK: - functions
    
    func loadImage() {
        if let posterPath = self.posterPath {
            MWN.sh.getImage(size: .w154,
                            imagePath: posterPath,
                            successHandler: { [weak self] (image) in
                                if let image = image {
                                    self?.image = image
                                } else {
                                    self?.image = UIImage(named: "noImage")
                                }
                                self?.imageLoaded?(self?.id ?? -1)
            }) { (error) in
                error.printInConsole()
            }
        } else {
            self.image = UIImage(named: "noImage")
            self.imageLoaded?(self.id)
        }
    }
}
