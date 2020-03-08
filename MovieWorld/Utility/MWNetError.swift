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
