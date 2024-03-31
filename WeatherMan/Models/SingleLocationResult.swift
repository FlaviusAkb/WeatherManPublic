// Result.swift
// WeatherMan
//
// Created by Flavius Lucian Ilie on 08.12.2023.

import Foundation

struct SingleLocationResult: Codable, Equatable {
    
    let location: Location?
    let current: CurrentWeather?
    let forecast: Forecast?
    var alerts: AlertContainer?
    
    static func == (lhs: SingleLocationResult, rhs: SingleLocationResult) -> Bool {
        return lhs.location == rhs.location &&
        lhs.current == rhs.current &&
        lhs.forecast == rhs.forecast
    }
    
    static var defaultResponse = SingleLocationResult(
        location: Location(name: "Example City", localtime: "2023-01-01T12:00:00"),
        current: CurrentWeather(
            lastUpdated: "2023-01-01T12:00:00",
            tempC: 20.0,
            tempF: 68.0,
            condition: CurrentWeather.CurrentCondition(text: "Clear", icon: "01d"),
            airQuality: CurrentWeather.AirQuality(
                index: 50.0)),
        forecast: Forecast( forecastDays: [
            Forecast.ForecastDay(
                day: Forecast.ForecastDay.Day(
                    maxTempC: 25.0,
                    maxTempF: 77.0,
                    avgHumidity: 70.0,
                    maxWindKph: 10.0,
                    dailyChanceOfRain: 30.0,
                    dailyChanceOfSnow: 0.0,
                    condition: Forecast.ForecastDay.Day.CurrentCondition(text: "Partly Cloudy", icon: "02d"),
                    airQuality: Forecast.ForecastDay.Day.AirQuality(index: 55.0)
                ),
                date: "2023-01-02",
                hours: []
            ),
            Forecast.ForecastDay(
                day: Forecast.ForecastDay.Day(
                    maxTempC: 35.0,
                    maxTempF: 97.0,
                    avgHumidity: 20.0,
                    maxWindKph: 40.0,
                    dailyChanceOfRain: 30.0,
                    dailyChanceOfSnow: 0.0,
                    condition: Forecast.ForecastDay.Day.CurrentCondition(text: "Cloudy", icon: "02d"),
                    airQuality: Forecast.ForecastDay.Day.AirQuality(index: 55.0)
                ),
                date: "2023-01-03",
                hours: []
            ),
            Forecast.ForecastDay(
                day: Forecast.ForecastDay.Day(
                    maxTempC: 25.0,
                    maxTempF: 77.0,
                    avgHumidity: 70.0,
                    maxWindKph: 10.0,
                    dailyChanceOfRain: 30.0,
                    dailyChanceOfSnow: 0.0,
                    condition: Forecast.ForecastDay.Day.CurrentCondition(text: "Partly Cloudy", icon: "02d"),
                    airQuality: Forecast.ForecastDay.Day.AirQuality(index: 55.0)
                ),
                date: "2023-01-04",
                hours: []
            ),]),
        alerts: AlertContainer(alert: [
            WeatherAlert(
                headline: "Alert 1",
                severity: "Moderate",
                areas: "City Area",
                event: "Rainfall"
            ),
            WeatherAlert(
                headline: "Alert 2",
                severity: "High",
                areas: "Mountain Region",
                event: "Snowfall"
            ),
            WeatherAlert(
                headline: "Alert 3",
                severity: "Low",
                areas: "Coastal Area",
                event: "High Wind"
            ),
        ]))
    
    
}












