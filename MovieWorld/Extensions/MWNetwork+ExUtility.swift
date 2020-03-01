//
//  MWNetwork+ExUtility.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/1/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

extension MWNetwork {
    func getUrlWithParams(fullPath: String, params: [String: String]) -> String {
        var url: String = fullPath
        if params.count > 0 {
            url += "?"
            for param in params {
                if url[url.count - 1] != "?" &&
                    url[url.count - 1] != "&" {
                    url += "&"
                }
                let key: String = param.key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? param.key
                let value: String = param.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? param.value
                url += "\(key)=\(value)"
            }
        }
        return url
    }
}
