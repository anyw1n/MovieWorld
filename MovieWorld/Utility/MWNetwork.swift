//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit
import Alamofire

typealias MWN = MWNetwork

enum MWNetError {
    case incorrectUrl(url: String)
    case networkError(error: Error)
    case serverError(statusCode: Int)
    case parsingError(error: Error)
    case unauthError(apiKey: String)
    
    case unknown
}

struct URLPaths {
    static let popularMovies: String = "movie/popular"
    static let topMovies: String = "movie/top_rated"
}

struct Genres {
    static var movies: [Int: String] = [:]
    static var tv: [Int: String] = [:]
}

class MWNetwork {
    
    static let sh = MWNetwork()
    
    let apiKey = "79d5894567be5b76ab7434fc12879584"
    let baseURL = "https://api.themoviedb.org/3"
    
    private init() {}
    
    func request<T>(typeOfResult: T.Type,
                    url path: String,
                    queryParameters: Parameters? = nil,
                    successHandler: @escaping (T) -> Void,
                    errorHandler: @escaping (MWNetError) -> Void) {
        let url = self.baseURL + path
        let key = "?api_key=" + self.apiKey
        
        AF.request(url + key, parameters: queryParameters).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200..<300:
                if let value = response.value as? T {
                    successHandler(value)
                } else {
                    if let error = response.error {
                        errorHandler(.parsingError(error: error))
                    }
                }
                break
            case 401:
                errorHandler(.unauthError(apiKey: self.apiKey))
                break
            case 404:
                errorHandler(.incorrectUrl(url: url))
                break
            default:
                errorHandler(.unknown)
                break
            }
        }
    }
    
    func getMovieGenres() {
        MWN.sh.request(typeOfResult: [[String: Any]].self,
                       url: "/genre/movie/list",
                       successHandler: { response in
            response.forEach { (genre) in
                Genres.movies[genre["id"] as? Int ?? -1] = genre["name"] as? String ?? "NaN"
            }
                        print("Genres loaded")
        },
                       errorHandler: { error in
                        print(error)
        })
    }
    
//    func getTVGenres() -> [Int: String] {
//        var genres: [Int: String] = [:]
//        MWN.sh.request(typeOfResult: [[String: Any]].self,
//                       url: "/genre/tv/list",
//                       successHandler: { response in
//            response.forEach { (genre) in
//                genres[genre["id"] as? Int ?? -1] = genre["name"] as? String ?? "NaN"
//            }
//        },
//                       errorHandler: { error in })
//        return genres
//    }
}
