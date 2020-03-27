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

class MWNetwork {
    
    //MARK: - variables
    
    static let sh = MWNetwork()
    
    private let apiKey = "79d5894567be5b76ab7434fc12879584"
    private let baseURL = "https://api.themoviedb.org/3"
    
    //MARK: - init
    
    private init() {}
    
    //MARK: - functions
    
    func request<T: Decodable>(url path: String,
                               queryParameters: Parameters? = nil,
                            successHandler: @escaping (T) -> Void,
                            errorHandler: @escaping (MWNetError) -> Void) {
        let url = self.baseURL + path
        let key = "?api_key=" + self.apiKey
        var parameters: Parameters = queryParameters ?? [:]
        if let languageCode = Locale.current.languageCode {
            parameters["language"] = languageCode
        }
        if let regionCode = Locale.current.regionCode {
            parameters["region"] = regionCode
        }
        
        AF.request(url + key, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                var data: Data?
                switch path {
                case URLPaths.configuration:
                    if let json = (value as? [String: Any])?["images"] {
                        data = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .prettyPrinted)
                    }
                case URLPaths.movieGenres, URLPaths.tvGenres:
                    if let json = (value as? [String: Any])?["genres"] {
                        data = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .prettyPrinted)
                    }
                default:
                    if let json = (value as? [String: Any])?["results"] {
                        data = try? JSONSerialization.data(withJSONObject: json,
                                                           options: .prettyPrinted)
                    }
                }
                do {
                    if let data = data {
                        try successHandler(JSONDecoder().decode(T.self, from: data))
                    }
                } catch {
                    errorHandler(.parsingError(error))
                }
                break
            case .failure(let error):
                if let code = error.responseCode {
                    switch code {
                    case 401:
                        errorHandler(.unauthError(apiKey: self.apiKey))
                        break
                    case 404:
                        errorHandler(.incorrectUrl(url: url))
                        break
                    default:
                        errorHandler(.serverError(statusCode: code))
                        break
                    }
                } else {
                    if let underlyingError = error.underlyingError as NSError?,
                    underlyingError.code == URLError.Code.notConnectedToInternet.rawValue {
                        errorHandler(.networkError(error))
                    } else {
                        errorHandler(.unknown(error: error))
                    }
                }
                break
            }
        }
    }
}
