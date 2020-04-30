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

    // MARK: - variables

    static let sh = MWNetwork()

    private let apiKey = "79d5894567be5b76ab7434fc12879584"
    private let baseUrl = "https://api.themoviedb.org/3"

    // MARK: - init

    private init() {}

    // MARK: - functions

    func request<T: Decodable>(url path: String,
                               queryParameters: Parameters? = nil,
                               successHandler: @escaping (T) -> Void,
                               errorHandler: @escaping (MWNetError) -> Void) {
        let url = self.baseUrl + path + "?api_key=" + self.apiKey
        var parameters: Parameters = queryParameters ?? [:]
        if let languageCode = Locale.current.languageCode, parameters["language"] == nil {
            parameters["language"] = languageCode
        }
        if let regionCode = Locale.current.regionCode, parameters["region"] == nil {
            parameters["region"] = regionCode
        }

        AF.request(url, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                do {
                    if let data = try? JSONSerialization.data(withJSONObject: value,
                                                              options: .prettyPrinted) {
                        try successHandler(JSONDecoder().decode(T.self, from: data))
                    }
                } catch {
                    errorHandler(.parsingError(error))
                }
            case .failure(let error):
                if let code = error.responseCode {
                    switch code {
                    case 401:
                        errorHandler(.unauthError(apiKey: self.apiKey))
                    case 404:
                        errorHandler(.incorrectUrl(url: url))
                    default:
                        errorHandler(.serverError(statusCode: code))
                    }
                } else {
                        errorHandler(.unknown(error: error))
                }
            }
        }
    }
}
