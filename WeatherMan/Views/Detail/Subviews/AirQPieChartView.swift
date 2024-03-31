//
//  AirQPieChartView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 20.12.2023.
//

import SwiftUI

struct PieChart: View {
    var data: Double
    var time: String
    
    var body: some View {
 
            ZStack {
                Circle()
                    .trim(from: 0.25, to: 1.0)
                    .trim(from: 0, to: CGFloat(data / 10))
                    .stroke(color(for: data), lineWidth: 5)
                    .rotationEffect(.degrees(45))
                
                if data < 10 {
                    Circle()
                        .trim(from: 0.25, to: 1.0)
                        .trim(from: CGFloat(data / 10), to: 1.0)
                        .stroke(Color.gray, lineWidth: 5)
                        .rotationEffect(.degrees(45))
                }
                VStack {
                    Text(String(Int(data)))
                        .font(.title)
                        .foregroundColor(color(for: data))
                    Text(time)
                        .font(.footnote)
                        .foregroundColor(color(for: data))
                }
            }
   
        
    }
    
    private func color(for value: Double) -> Color {
        switch value {
        case 1...3:
            return .green
        case 4...6:
            return .orange
        case 7...9:
            return .red
        case 10:
            return .purple
        default:
            return .black
        }
    }
}

struct AirQPieChartView: View {
    var airQ: Double
    var time: String
    
    var body: some View {
        VStack {
            PieChart(data: airQ, time: time)
                .frame(width: 80, height: 80)
                .padding()
        }
    }
}

#Preview {
    AirQPieChartView(airQ: 4.0, time: "13:55")
}
