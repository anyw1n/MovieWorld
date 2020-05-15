//
//  MWNetError.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation
import Alamofire

enum MWNetError {

    case incorrectUrl(url: String)
    case networkError(_ error: AFError)
    case serverError(statusCode: Int)
    case parsingError(_ error: Error)
    case unauthError(apiKey: String)
    case unknown(error: AFError)

    func printInConsole() {
        print(self.getDescription())
    }

    func getDescription() -> String {
        switch self {
        case .incorrectUrl(let url):
            return "Error! Incorrect URL: %@".localized(args: url)
        case .networkError(let error):
            let localizedError =
                error.underlyingError?.localizedDescription ?? error.localizedDescription
            return "Network error: %@".localized(args: localizedError)
        case .serverError(let statusCode):
            return "Server error, status code: %@".localized(args: statusCode)
        case .parsingError(let error):
            return "Error! Can't parse: %@".localized(args: error.localizedDescription)
        case .unauthError(let apiKey):
            return "Error! Incorrect api key: %@".localized(args: apiKey)
        case .unknown(let error):
            let localizedError =
                error.underlyingError?.localizedDescription ?? error.localizedDescription
            return "Error! %@".localized(args: localizedError)
        }
    }
}
