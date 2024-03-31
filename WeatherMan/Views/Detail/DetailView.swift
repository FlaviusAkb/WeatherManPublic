//
//  DetailView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 08.12.2023.
//

import SwiftUI

struct DetailView: View {
    var displayedDTO: WeatherDataDTO
    
    var index: Int
    var submitLocation: (() -> Void)?

    var body: some View {
        NavigationStack {
            VStack {
                LocationCardView(
                    height: 330,
                    temperature: displayedDTO.dailyTemperature(at: index),
                    date: displayedDTO.dailyDate(at: index),
                    time: displayedDTO.currentFormattedTimeHMM,
                    condition: displayedDTO.dailyCondition(at: index),
                    location: displayedDTO.currentLocationName,
                    latestUpdate: "Latest update: \(displayedDTO.currentFormattedLastUpdateHM)",
                    isDetailView: true
                )
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        self.hourlyForecastSection
                        
                        self.airQualitySection
                        
                        self.atmosCardSection
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
