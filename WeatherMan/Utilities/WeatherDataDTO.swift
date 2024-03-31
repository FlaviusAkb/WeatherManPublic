//
//  WeatherDataDTO.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 22.12.2023.
//

import Combine
import Foundation
@MainActor
class WeatherDataDTO {
    
    var result: SingleLocationResult
    var isCelsius: Bool
    
    init(result: SingleLocationResult, isCelsius: Bool = true) {
        self.result = result
        self.isCelsius = isCelsius
    }
}

extension WeatherDataDTO {

    // MARK: - Current Weather
    
    var formattedCurrentDate: String {
        let condition = currentCondition
        let time = currentFormattedTimeDMY
//        print("\(condition), \(time)")
        return "\(condition), \(time)"
    }
    
    var currentCondition: String {
        return self.result.current?.condition.text ?? "Unknown condition"
    }
    var currentLocationName: String {
        return self.result.location?.name ?? "Unknown location name"
    }
    var currentConditionIcon: String {
        return self.result.current?.condition.icon ?? "Unknown condition icon"
    }
    var currentLocationTemperature: Double {
        return isCelsius ? self.result.current?.tempC ?? 0.0 : self.result.current?.tempF ?? 0.0
    }
    
    var currentFormattedTimeDMY: String {
        formattedTimeString(from: self.result.location?.localtime ?? "Unknown time" , expectedResult: "dd MMM yyyy")
    }
    var currentFormattedTimeHMM: String {
        formattedTimeString(from: self.result.location?.localtime ?? "Unknown time" , expectedResult: "HH:mm a")
    }
    var currentFormattedLastUpdateHM: String {
        formattedTimeString(from:self.result.current?.lastUpdated ?? "Unknown time" , expectedResult: "HH:mm a")
    }
    
    // MARK: - Hourly Forecast
    
    var hourlyForecastCount: Int {
        return self.result.forecast?.forecastDays[0].hours.count ?? 0
    }
    
    func hourlyCondition(at index: Int) -> String {
        return self.result.forecast?.forecastDays[0].hours[index].condition.icon ?? "Unknown condition"
    }
    
    func hourlyTemperature(at index: Int) -> TemperatureUnit {
        let temperatureValue = (isCelsius ?
                                self.result.forecast?.forecastDays[0].hours[index].tempC :
                                    self.result.forecast?.forecastDays[0].hours[index].tempF) ?? 0.0
        let temperatureUnit: TemperatureUnit.Unit = isCelsius ? .celsius : .fahrenheit
        return TemperatureUnit(value: temperatureValue, unit: temperatureUnit)
    }
    
    func formattedHourlyTimeHM(at index: Int) -> String {
        return formattedTimeString(from: self.result.forecast?.forecastDays[0].hours[index].time ?? "Unknown condition" , expectedResult: "HH:mm a")
    }
    
    // MARK: - Daily Forecast
    
    var dailyForecastCount: Int {
        return self.result.forecast?.forecastDays.count ?? 0
    }
    
    func dailyCondition(at index: Int) -> String {
        return self.result.forecast?.forecastDays[index].day.condition.icon ?? "Unknown condition"
    }
    
    func dailyTemperature(at index: Int) -> TemperatureUnit {
        let temperatureValue = (isCelsius ?
                                self.result.forecast?.forecastDays[index].day.maxTempC :
                                    self.result.forecast?.forecastDays[index].day.maxTempF) ?? 0.0
        let temperatureUnit: TemperatureUnit.Unit = isCelsius ? .celsius : .fahrenheit
        return TemperatureUnit(value: temperatureValue, unit: temperatureUnit)
    }
    
    func dailyTitle(at index: Int) -> String {
        return formattedTimeString(from: self.result.forecast?.forecastDays[index].date ?? "Unknown condition", expectedResult: "EEEE")
    }
    
    func dailyDate(at index: Int) -> String {
        let condition = self.result.forecast?.forecastDays[index].day.condition.text 
        let time = formattedTimeString(from: self.result.forecast?.forecastDays[index].date ?? "Unknown condition", expectedResult: "dd MMM yyyy")
        return "\(condition ?? "Unknown condition"), \(time)"
    }
    
    func dailyCaption(at index: Int) -> String {
        return self.result.forecast?.forecastDays[index].day.condition.text ?? "Unknown condition"
    }
    
    func dailyAirQ(at index: Int) -> Double {
        return self.result.forecast?.forecastDays[index].day.airQuality.index ?? 0.0
    }
    
    func dailyHourlyForecastCount(at index: Int) -> Int {
        return self.result.forecast?.forecastDays[index].hours.count ?? 0
    }
    
    func dailyHourlyCondition(at index: Int, with hourIndex: Int) -> String {
        return self.result.forecast?.forecastDays[index].hours[hourIndex].condition.icon ?? "Unknown condition"
    }
    
    func dailyHourlyTemperature(at index: Int, with hourIndex: Int) -> TemperatureUnit {
        let temperatureValue = (isCelsius ?
                                self.result.forecast?.forecastDays[index].hours[hourIndex].tempC :
                                    self.result.forecast?.forecastDays[index].hours[hourIndex].tempF) ?? 0.0
        let temperatureUnit: TemperatureUnit.Unit = isCelsius ? .celsius : .fahrenheit
        return TemperatureUnit(value: temperatureValue, unit: temperatureUnit)
    }
    func dailyHourlyAirQ(at index: Int, with hourIndex: Int) -> Double {
        return self.result.forecast?.forecastDays[index].hours[hourIndex].airQuality.index ?? 0.0
    }
    
    
    
//    func dailyAvgHumidity(at index: Int) -> Double {
//        return self.result.forecast?.forecastDays[index].day.avgHumidity ?? 0
//    }
//    
//    func dailyMaxWindKph(at index: Int) -> Double {
//        return self.result.forecast?.forecastDays[index].day.maxWindKph ?? 0
//    }
//    
//    func dailyChanceOfRain(at index: Int) -> Double {
//        return self.result.forecast?.forecastDays[index].day.dailyChanceOfRain ?? 0
//    }
//    
//    func dailyChanceOfSnow(at index: Int) -> Double {
//        return self.result.forecast?.forecastDays[index].day.dailyChanceOfSnow ?? 0
//    }
    
    func dailyAvgHumidity(at index: Int, with hourIndex: Int) -> Double {
        return self.result.forecast?.forecastDays[index].hours[hourIndex].humidity ?? 0
    }
    
    func dailyMaxWindKph(at index: Int, with hourIndex: Int) -> Double {
        return self.result.forecast?.forecastDays[index].hours[hourIndex].windKph ?? 0
    }
    
    func dailyChanceOfRain(at index: Int, with hourIndex: Int) -> Double {
        return self.result.forecast?.forecastDays[index].hours[hourIndex].chanceOfRain ?? 0
    }
    
    func dailyChanceOfSnow(at index: Int, with hourIndex: Int) -> Double {
        return self.result.forecast?.forecastDays[index].hours[hourIndex].chanceOfSnow ?? 0
    }
    
    
    // MARK: - General
    func formattedTimeString(from dateString: String, expectedResult: String) -> String {
        let dateFormatter = DateFormatter()
        let formats = ["yyyy-MM-dd HH:mm", "yyyy-MM-dd"]

        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                dateFormatter.dateFormat = expectedResult
                return dateFormatter.string(from: date)
            }
        }
        return "Unknown"
    }
}
