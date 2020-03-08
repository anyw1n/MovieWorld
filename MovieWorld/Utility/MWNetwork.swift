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
    
    func getImage(size: Sizes,
                  imagePath: String,
                  handler: @escaping (UIImage?) -> Void) {
        guard let baseURL = MWS.sh.configuration?.secureBaseURL else { return }
        let url = baseURL + size.rawValue + imagePath
        AF.request(url).responseData(completionHandler: { (response) in
            guard let data = response.data else { return }
            handler(UIImage(data: data))
        })
    }
}
