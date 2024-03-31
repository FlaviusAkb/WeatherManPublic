//
//  LocationCardView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 08.12.2023.
//

import SwiftUI

struct LocationCardView: View {
    var height: CGFloat?
    var lgLeft: Color = Color.lightBlue
    var lgRight: Color = Color.darkBlue
    var lgDropshadow: Color = Color.dropShadow
    
    var temperature: TemperatureUnit
    var date: String
    var time: String
    var condition: String
    var location: String
    var latestUpdate: String
    var isDetailView: Bool
    
    var cardHeight: CGFloat? {
        height ?? 200
    }
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: isDetailView ? 0 : 10)
                .fill(LinearGradient(gradient: Gradient(colors: [lgLeft, lgRight]), startPoint: .leading, endPoint: .trailing))
                .shadow(color: lgDropshadow, radius: 5, x: 0, y: 4)
                .frame(height: cardHeight)
                .ignoresSafeArea()
            
            VStack(alignment: isDetailView ? .center : .leading) {
                
                DateView(currentDate: date, currentTime: time, isDetailView: isDetailView)
                
                WeatherInfoView(currentCondition: condition, temperature: temperature, currentLocation: location, isDetailView: isDetailView)
                
                UpdateButtonView(latestUpdate: latestUpdate)
            }
            .padding(.top, isDetailView ? 50 : 0)
            .foregroundStyle(.white)
            .frame(height: cardHeight)
            .padding(isDetailView ? 0 : 20)
            
            
        }
    }
}

struct DateView: View {
    var currentDate: String
    var currentTime: String
    var isDetailView: Bool
    
    var body: some View {
        if !isDetailView {
            HStack {
                Text(currentDate)
                Spacer()
                Text(currentTime)
            }
        } else {
            VStack {
                Text(currentDate)
                Text(currentTime)
            }
        }
    }
}

struct WeatherInfoView: View {
    var currentCondition: String
    var temperature: TemperatureUnit
    var currentLocation: String
    var isDetailView: Bool
    
    var body: some View {
        if !isDetailView {
            HStack {
                AsyncImageView(imageURL: "https://\(currentCondition.replacingOccurrences(of: "//", with: ""))")
                    .frame(width: 80, height: 80)
                
                VStack(alignment: .leading) {
                    Text(temperature.formattedValue)
                    Text(currentLocation).font(.title)
                }
            }
            .padding(.vertical)
        } else {
            VStack(alignment: .center) {
                AsyncImageView(imageURL: "https://\(currentCondition.replacingOccurrences(of: "//", with: ""))")
                    .frame(width: 80, height: 80)
                Text(temperature.formattedValue)
                Text(currentLocation).font(.title)
            }
        }
    }
}

struct UpdateButtonView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var latestUpdate: String
    
    var body: some View {
        Button{viewModel.submitLocation(text: viewModel.selectedOption) } label: {
            HStack {
                Text(latestUpdate)
                Image(systemName: "arrow.clockwise").rotationEffect(.degrees(45))
            }
        }
    }
}

struct AsyncImageView: View {
    var imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            if let image = phase.image {
                image.resizable().scaledToFit()
            } else if phase.error != nil {
                Text("Error loading image")
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    LocationCardView(temperature:  TemperatureUnit(value: 25.0, unit: .celsius), date: "Partly cloudy, 13 December 2024", time: "3:30PM", condition: "cloud.sun.rain.fill", location: "John Doe", latestUpdate: "Terakhir update 3.00 PM", isDetailView: false)
}
