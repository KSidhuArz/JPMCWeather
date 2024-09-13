//
//  URLBuilder.swift
//  WeatherJPMC
//
//  Created by Kulbir Singh on 9/11/24.
//

import Foundation

///This class using to build a url with the help of builder design pattren
class URLBuilder{
    var component: URLComponents
    
    init() {
        var endUrl = URLComponents()
        endUrl.scheme = "https"
        endUrl.host = "api.openweathermap.org"
        endUrl.path = "/data/2.5/weather"
        self.component = endUrl
    }
    
//    func setPatch(path:String) -> URLBuilder{
//        component.path = "/data/2.5/weather?"
//        return self
//    }
    
    func setQuery(search: String) -> URLBuilder{
        component.queryItems = [URLQueryItem(name: "q", value: search), URLQueryItem(name: "appid", value: "3eae7c5e22e377765d195740546fb720")]
        return self
    }
    
    func build() throws -> URL? {
        guard let url = self.component.url else{
            throw NetworkError.invalidUrl
        }
        return url
    }
}
