//
//  MWConfiguration.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/7/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Foundation

struct MWConfiguration: Decodable {

    private enum CodingKeys: String, CodingKey {
        case baseURL = "base_url", secureBaseURL = "secure_base_url"
    }
    
    //MARK: - variables

    let baseURL: String?
    let secureBaseURL: String?
    
    //MARK: - init

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseURL = (try? container.decode(String.self, forKey: .baseURL))
        self.secureBaseURL = (try? container.decode(String.self, forKey: .secureBaseURL))
    }
}
