//
//  Forecast.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 03.03.2024.
//

import Foundation

struct Forecast: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
    let forecastDays: [ForecastDay]
    
    struct ForecastDay: Codable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case day, date
            case hours = "hour"
        }
        let day: Day
        let date: String
        let hours: [Hour]
        
        struct Day: Codable, Equatable {
            private enum CodingKeys: String, CodingKey {
                case airQuality = "air_quality"
                case condition
                case maxTempC = "maxtemp_c"
                case maxTempF = "maxtemp_f"
                case avgHumidity = "avghumidity"
                case maxWindKph = "maxwind_kph"
                case dailyChanceOfRain = "daily_chance_of_rain"
                case dailyChanceOfSnow = "daily_chance_of_snow"
            }
            
            let maxTempC: Double
            let maxTempF: Double
            let avgHumidity: Double
            let maxWindKph: Double
            let dailyChanceOfRain: Double
            let dailyChanceOfSnow: Double
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
                var index: Double?
            }
        }
    }
    struct Hour: Codable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case condition, time, humidity
            case tempC = "temp_c"
            case tempF = "temp_f"
            case airQuality = "air_quality"
            
            case windKph = "wind_kph"
            case chanceOfRain = "chance_of_rain"
            case chanceOfSnow = "chance_of_snow"
        }
        
        var time: String
        let tempC: Double
        let tempF: Double
        let condition: DayCondition
        let airQuality: AirQuality
        
        let humidity: Double
        let windKph: Double
        let chanceOfRain: Double
        let chanceOfSnow: Double
        
        struct DayCondition: Codable, Equatable {
            let text: String
            let icon: String
        }
        struct AirQuality: Codable, Equatable {
            private enum CodingKeys: String, CodingKey {
                case index = "gb-defra-index"
            }
            var index: Double?
        }
    }
}
