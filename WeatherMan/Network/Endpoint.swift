//
//  Endpoint.swift
//  WeatherMan
//
//  Created by Bogdan Nica on 30.01.2024.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case getSingleLocationData(for: String)
    
    var apiKey: String { APIManager.shared.apiKey }
    
    var displayErrors: Bool {
        switch self {
        case .getSingleLocationData:
            return true
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getSingleLocationData:
            return .get
        }
    }
    
    var url: URL {
        switch self {
        case .getSingleLocationData(let location):
            if let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(location)&days=3&aqi=yes&alerts=yes") {
                return url
            } else {
                fatalError("Invalid URL")
            }
        }
    }
}
