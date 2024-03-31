//
//  AlertContainer.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 03.03.2024.
//

import Foundation

struct AlertContainer: Codable, Equatable {
    var alert: [WeatherAlert]
}
struct WeatherAlert: Codable, Equatable {
    
    var headline: String
    //    var msgType: String
    var severity: String
    //    var urgency: String
    var areas: String
    //    var category: String
    //    var certainty: String
    var event: String
    //    var note: String
    //    var effective: Date
    //    var expires: Date
    //    var desc: String
    //    var instruction: String
}
