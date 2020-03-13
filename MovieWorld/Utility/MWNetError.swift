//
//  MWNetError.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/8/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

enum MWNetError {
    case incorrectUrl(url: String)
    case networkError(_ error: Error)
    case serverError(statusCode: Int)
    case parsingError(_ error: Error)
    case unauthError(apiKey: String)
    case unknown(error: Error)
    
    func printInConsole() {
        switch self {
        case .incorrectUrl(let url):
            print("Error! Incorrect URL: \(url)")
        case .networkError(let error):
            print("Network error: \(error.localizedDescription)")
        case .serverError(let statusCode):
            print("Server error, status code: \(statusCode)")
        case .parsingError(let error):
            print("Error! Can't parse: \(error.localizedDescription)")
        case .unauthError(let apiKey):
            print("Error! Incorrect api key: \(apiKey)")
        case .unknown(let error):
            print("Unknown error! \(error.localizedDescription)")
        }
    }
}
