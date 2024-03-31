//
//  ThumbCardView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 08.12.2023.
//

import SwiftUI

struct TemperatureUnit {
    var value: Double
    var unit: Unit
    
    enum Unit {
        case celsius
        case fahrenheit
    }
    
    var formattedValue: String {
        let formattedValue: String
        switch unit {
        case .celsius:
            formattedValue = formatTemperature(value)
            return "\(formattedValue)°C"
        case .fahrenheit:
            let valueInFahrenheit = (value * 9/5) + 32
            formattedValue = formatTemperature(valueInFahrenheit)
            return "\(formattedValue)°F"
        }
    }
    
    private func formatTemperature(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}

struct ThumbCardView: View {
    var height: CGFloat = 130 // default height
    var width: CGFloat = 80
    
    var background: Color = Color.thumbCard
    var lgDropshadow: Color = Color.thumbCard
    
    var condition: String
    var temperature: TemperatureUnit
    var hour: String
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(background)
                .shadow(color:lgDropshadow, radius: 4, x: 0, y: 4)
                .frame(width: width, height: height)
            
            VStack(alignment: .center) {
                AsyncImage(url: URL(string: "https://\(condition.replacingOccurrences(of: "//", with: ""))")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    } else if phase.error != nil {
                        Text("There was an error loading the image.")
                    } else {
                        ProgressView()
                    }
                }
                Text(temperature.formattedValue)
                    .font(.subheadline.bold())
                Text(hour)
                    .font(.caption)
                
            }
            .foregroundStyle(.black)
            .frame(width: width, height: height)
            
        }
    }
}

#Preview {
    HomeView()
}
