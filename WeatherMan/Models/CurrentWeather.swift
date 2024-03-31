//
//  CurrentWeather.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 03.03.2024.
//

import Foundation

struct CurrentWeather: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case airQuality = "air_quality"
        case condition
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
    }
    
    let lastUpdated: String
    let tempC: Double
    let tempF: Double
    let condition: CurrentCondition
    let airQuality: AirQuality
    
    struct CurrentCondition: Codable, Equatable {
        let text: String
        let icon: String
    }
    
    struct AirQuality: Codable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case index = "gb-defra-index"
        }
        var index: Double
    }
}
