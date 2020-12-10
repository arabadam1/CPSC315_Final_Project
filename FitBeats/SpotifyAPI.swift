//
//  SpotifyAPI.swift
//  FitBeats
//
//  Created by Dillon Shipley on 12/8/20.
//

import Foundation

struct SpotifyAPI {
    static let apiKey = "6fbaa5569f1a443e8ad6b48a8af3dddd"
    static let baseURL = "https://api.spotify.com/v1/tracks/"
    
    static func spotifyURL()->URL{
        let params = [
            "no clue" : "no clue",
            "no clue" : "no clue"
        ]
        var queryItems = [URLQueryItem]()
        for(key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(string: SpotifyAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print(url)
        return url
    }
}
