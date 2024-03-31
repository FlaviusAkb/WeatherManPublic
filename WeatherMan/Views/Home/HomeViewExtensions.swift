//
//  HomeViewExtensions.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 19.12.2023.
//

import SwiftUI

extension HomeView {
    
    var settingsButtonView: some View {
        NavigationLink {
            APIKeyView()
        } label: {
            Image(systemName: "gear")
                .font(.headline)
        }
    }
    
    var alertView: some View {
        VStack {
            if !displayedAlerts.isEmpty {
                ForEach(displayedAlerts.indices, id: \.self) { index in
                    let alert = displayedAlerts[index]
                    AlertCardView(
                        title: alert.headline,
                        caption: alert.event,
                        background: Color.alertCardBackground.opacity(0.3),
                        symbol: "bolt.horizontal.fill"
                    )
                }
            } else {
                AlertCardView(
                    title: "No alerts",
                    caption: "No alerts in progress",
                    background: Color.alertCardBackground.opacity(0.1),
                    symbol: "rainbow"
                )
            }
        }
    }
    var searchBarView: some View {
        SearchBarView(
            selectedCity: $viewModel.selectedOption,
            isSearching: $viewModel.searchClosed,
            searchText: $viewModel.searchText
        )
    }
    var locationCardView: some View {
        LocationCardView(
            temperature: TemperatureUnit(
                value: displayedDTO.currentLocationTemperature,
                unit: displayedDTO.isCelsius ? .celsius : .fahrenheit
            ),
            date: displayedDTO.formattedCurrentDate,
            time: displayedDTO.currentFormattedTimeHMM,
            condition: displayedDTO.currentConditionIcon,
            location: displayedDTO.currentLocationName,
            latestUpdate: "Latest update: \(displayedDTO.currentFormattedLastUpdateHM)",
            isDetailView: false
        )
    }
    var dailyForecastView: some View {
        ForEach(0..<(displayedDTO.dailyForecastCount), id: \.self) { index in
            WeatherLinkView(
                currentCondition: displayedDTO.dailyCondition(at: index),
                title: displayedDTO.dailyTitle(at: index),
                caption: displayedDTO.dailyCaption(at: index),
                temperature: displayedDTO.dailyTemperature(at: index),
                destination: DetailView(displayedDTO: displayedDTO, index: index, submitLocation: { viewModel.submitLocation(text: displayedDTO.currentLocationName)} ),
                isAlertCard: false,
                displayedDTO: displayedDTO,
                index: index
            )
        }
    }
    var hourlyForecastView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<(displayedDTO.hourlyForecastCount), id: \.self) { hourIndex in
                    let startingHour = Int(displayedDTO.currentFormattedTimeHMM.prefix(2))
                    if startingHour ?? 0 <= hourIndex {
                        ThumbCardView(
                            condition: displayedDTO.dailyHourlyCondition(at: 0, with: hourIndex),
                            temperature: displayedDTO.dailyHourlyTemperature(at:0, with: hourIndex),
                            hour: displayedDTO.formattedHourlyTimeHM(at: hourIndex)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
