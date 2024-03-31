//
//  Response.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 03.03.2024.
//

import Foundation

struct ErrorResponse: Decodable {
    struct ErrorDetail: Decodable {
        let code: Int
        let message: String
    }
    
    let error: ErrorDetail?
}
struct Response: Codable {
    var results: [SingleLocationResult]
}
