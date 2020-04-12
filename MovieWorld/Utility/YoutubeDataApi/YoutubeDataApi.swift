//
//  YoutubeDataApi.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 4/11/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import Alamofire

typealias YTApi = YoutubeDataApi

class YoutubeDataApi {
    
    // MARK: - variables
    
    static let sh = YoutubeDataApi()
    
    private let apiKey = "AIzaSyATLZzgPt4JSMJWdXii2FiYRYbQ_9hI7e4"
    private let baseUrl = "https://www.googleapis.com/youtube/v3"
    
    // MARK: - init
    
    private init() { }
    
    // MARK: - functions
    
    func request<T: YoutubeDataVideo>(videoId: String,
                                      parameters: Parameters = [:],
                                      successHandler: @escaping (T) -> Void) {
        
        let url = self.baseUrl + YoutubeDataVideoList<T>.path
        var parameters: Parameters = parameters
        parameters["part"] = T.part
        parameters["id"] = videoId
        parameters["key"] = self.apiKey
        
        AF.request(url, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let data = try? JSONSerialization.data(withJSONObject: value,
                                                             options: .prettyPrinted),
                    let videoList = try? JSONDecoder().decode(YoutubeDataVideoList<T>.self,
                                                              from: data),
                    let video = videoList.items.first else { return }
                successHandler(video)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
