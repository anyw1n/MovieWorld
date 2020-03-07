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
    
    func printInConsole() {
        switch self {
        case .incorrectUrl(let url):
            print("Error! Incorrect URL: \(url)")
        case .networkError(let error):
            print("Error! Network error: \(error)")
        case .serverError(let statusCode):
            print("Error! Server error, status code: \(statusCode)")
        case .parsingError(let error):
            print("Error! Can't parse: \(error)")
        case .unauthError(let apiKey):
            print("Error! Incorrect api key: \(apiKey)")
        case .unknown:
            print("Unknown error!")
        }
    }
}

struct URLPaths {
    static let popularMovies: String = "/movie/popular"
    static let topMovies: String = "movie/top_rated"
    static let discoverMovies: String = "/discover/movie"
    static let upcomingMovies: String = "/movie/upcoming"
}

class MWNetwork {
    
    static let sh = MWNetwork()
    
    let apiKey = "79d5894567be5b76ab7434fc12879584"
    let baseURL = "https://api.themoviedb.org/3"
    
    private init() {}
    
    func request<Decodable>(url path: String,
                            queryParameters: Parameters? = nil,
                            successHandler: @escaping (Decodable) -> Void,
                            errorHandler: @escaping (MWNetError) -> Void) {
        let url = self.baseURL + path
        let key = "?api_key=" + self.apiKey
        
        AF.request(url + key, parameters: queryParameters).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200..<300:
                if let value = response.value as? Decodable {
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
}
