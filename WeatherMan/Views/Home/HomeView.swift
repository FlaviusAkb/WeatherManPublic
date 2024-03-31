//
//  HomeView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 12.12.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    var displayedDTO: WeatherDataDTO {
        viewModel.displayedDTO
    }
    var displayedAlerts: [WeatherAlert] {
        if let alertsContainer = viewModel.displayedDTO.result.alerts {
            return alertsContainer.alert
        } else {
            return []
        }
    }
    var body: some View {
        NavigationStack {
            HStack {
                Button("Clear expired data") {
                    CacheManager.shared.cacheClearExpired()
                }
            }
            self.searchBarView
            List {
                if !APIManager.shared.apiKey.isEmpty {
                    ScrollView(.vertical) {
                        self.locationCardView
                        VStack(alignment: .leading) {
                            Text("Temperature by hour")
                                .font(.title)
                            self.hourlyForecastView
                            Text("Weather")
                                .font(.title)
                            self.alertView
                            self.dailyForecastView
                        }
                        Spacer()
                    }
                } else if APIManager.shared.apiKey.isEmpty {
                    Text("No API key set.")
                } else {
                    Text("No search history.")
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    self.settingsButtonView
                }
            }
            .sheet(isPresented: $viewModel.isApiPresented, content: {
                APIKeyView()
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(AlertManager.shared.alertTitle),
                    message: Text(AlertManager.shared.alertMessage),
                    dismissButton: .default(Text("OK")) { AlertManager.shared.showAlert = false
                    }
                )
            }
        }
        .accentColor(.black)
        .environmentObject(viewModel)
    }
}

#Preview {
    HomeView()
}
