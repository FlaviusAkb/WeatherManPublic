//
//  DetailViewExtensions.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 04.01.2024.
//

import SwiftUI

@MainActor
extension DetailView {
    
    var hourlyForecastSection: some View {
        VStack(alignment: .leading) {
            Text("Temperature by hour")
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<(displayedDTO.dailyHourlyForecastCount(at: index)), id: \.self) { hourIndex in
                        let startingHour = index != 0 ? 0 : Int(displayedDTO.currentFormattedTimeHMM.prefix(2))
                        if startingHour ?? 0 <= hourIndex {
                            ThumbCardView(
                                condition: displayedDTO.dailyHourlyCondition(at: index, with: hourIndex),
                                temperature: displayedDTO.dailyHourlyTemperature(at:index, with: hourIndex),
                                hour: displayedDTO.formattedHourlyTimeHM(at: hourIndex)
                            )
                        }
                    }
                }
            }
        }
    }
    
    var airQualitySection: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .font(.title)
            ScrollView(.horizontal) {
                HStack {
                    let startingHour = index == 0 ? Int(displayedDTO.currentFormattedTimeHMM.prefix(2)) ?? 0 : 0
                    ForEach(startingHour..<displayedDTO.dailyHourlyForecastCount(at: index), id: \.self) { hourIndex in
                        AirQCardView(
                            background: Color.thumbCard,
                            airQ: displayedDTO.dailyHourlyAirQ(at: index, with: hourIndex),
                            time: String("\(hourIndex):00")
                        )
                        .frame(maxWidth: 370)
                    }
                }
            }
        }
    }

    
    var atmosCardSection: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<(displayedDTO.dailyHourlyForecastCount(at: index)), id: \.self) { hourIndex in
                    let startingHour = index == 0 ? Int(displayedDTO.currentFormattedTimeHMM.prefix(2)) : 0
                    
                    if startingHour ?? 0 <= hourIndex {
                        VStack {
                            HStack {
                                AtmosCardView(
                                    title: "\(displayedDTO.dailyAvgHumidity(at: index, with: hourIndex)) %",
                                    caption: "Humidity",
                                    background: Color.thumbCard,
                                    symbol: "humidity"
                                )
                                AtmosCardView(
                                    title: "\(displayedDTO.dailyMaxWindKph(at: index, with: hourIndex)) Km/h",
                                    caption: "Wind",
                                    background: Color.thumbCard,
                                    symbol: "wind.circle"
                                )
                            }
                            HStack {
                                AtmosCardView(
                                    title: "\(displayedDTO.dailyChanceOfRain(at: index, with: hourIndex)) %",
                                    caption: "Raining chances",
                                    background: Color.thumbCard,
                                    symbol: "cloud.drizzle"
                                )
                                AtmosCardView(
                                    title: "\(displayedDTO.dailyChanceOfSnow(at: index, with: hourIndex))",
                                    caption: "Snowing chances",
                                    background: Color.thumbCard,
                                    symbol: "cloud.snow"
                                )
                            }
                            HStack {
                                Divider()
                                    .frame(width: 40, height: 2)
                                    .overlay(Color.darkBlue)
                                
                                Text("\(hourIndex):00")
                                
                                Divider()
                                    .frame(width: 40, height: 2)
                                    .overlay(Color.darkBlue)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.thumbCard))
                        .padding(.bottom)
                        .frame(maxWidth: 370)
                    }
                }
            }
        }
    }
}

#Preview {
    DetailView(displayedDTO: WeatherDataDTO(result: SingleLocationResult.defaultResponse), index: 0, submitLocation: { })
}
