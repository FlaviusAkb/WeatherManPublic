//
//  AlertManager.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 24.12.2023.
//

import Foundation
import SwiftUI

class AlertManager {
    
    static let shared = AlertManager()
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = "Message"
    @Published var alertTitle: String = "Title"
    
    init() {}
    
    func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        showAlert = true
    }
}
