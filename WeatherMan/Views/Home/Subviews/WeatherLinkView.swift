//
//  WeatherLinkView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 12.12.2023.
//

import SwiftUI

struct WeatherLinkView: View {
    var currentCondition: String
    var title: String
    var caption: String
    var temperature: TemperatureUnit
    var destination: any View
    var isAlertCard: Bool
    var displayedDTO: WeatherDataDTO
    
    var index: Int
    
    var body: some View {
        NavigationLink(destination: DetailView(displayedDTO: displayedDTO, index: index)) {
            HStack {
                if isAlertCard {
                    Image(systemName: "bolt.horizontal.fill")
                        .frame(width: 50, height: 50)
                } else {
                    AsyncImage(url: URL(string: "https://\(currentCondition.replacingOccurrences(of: "//", with: ""))")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Text("There was an error loading the image.")
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                }
                VStack(alignment: .leading) {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(caption)
                }
            }
            Spacer()
            if !isAlertCard {
                HStack {
                    Text(temperature.formattedValue)
                    Image(systemName: "chevron.right")
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(isAlertCard ? Color.alertCardBackground.opacity(0.3) : Color.emptyAlertCardBackground))
        .foregroundStyle(Color.black)
    }
}

#Preview {
    HomeView()
}
