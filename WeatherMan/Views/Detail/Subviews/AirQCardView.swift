//
//  AirQCardView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 20.12.2023.
//

import SwiftUI

struct AirQCardView: View {
    var background: Color
    var airQ: Double
    var time: String
    
    var body: some View {
        HStack {
            AirQPieChartView(airQ: airQ, time: time)
            VStack(alignment: .leading) {
                Text(AirQuality(for: airQ).title)
                   .font(.subheadline.bold())
                Text(AirQuality(for: airQ).caption)
                   .font(.footnote)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(background))
        .foregroundStyle(Color.black)
    }
}

#Preview {
    AirQCardView(background: .gray.opacity(0.3), airQ: 7.0, time: "13:55")
}



enum AirQuality: Equatable {
    case low(Double)
    case moderate(Double)
    case high(Double)
    case veryHigh(Double)
    case unknown(Double)

    var title: String {
        switch self {
        case .low:
            return "Air Pollution - Low"
        case .moderate:
            return "Air Pollution - Moderate"
        case .high:
            return "Air Pollution - High"
        case .veryHigh:
            return "Air Pollution - Very High"
        case .unknown:
            return "That's"
        }
    }

    var caption: String {
        switch self {
        case .low:
            return "Enjoy your usual outdoor activities."
        case .moderate:
            return "Enjoy your usual outdoor activities with care."
        case .high:
            return "Anyone experiencing discomfort such as sore eyes, cough, or sore throat should consider reducing activity, particularly outdoors."
        case .veryHigh:
            return "Reduce physical exertion, particularly outdoors, especially if you experience symptoms such as cough or sore throat."
        case .unknown:
            return "something unseen before."
        }
    }
}
extension AirQuality {
    init(for airQ: Double) {
        switch airQ {
        case 1...3:
            self = .low(airQ)
        case 4...6:
            self = .moderate(airQ)
        case 7...9:
            self = .high(airQ)
        case 10:
            self = .veryHigh(airQ)
        default:
            self = .unknown(airQ)
        }
    }
}
