//
//  APIKeyViewViewModel.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 21.12.2023.
//
import Combine
import Firebase
import FirebaseAnalytics
import Foundation
import SwiftUI

class APIKeyViewModel: ObservableObject {
    
    @Published var apiKey: String
    @Published var showAlert: Bool
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        apiKey = APIManager.shared.apiKey
        showAlert = AlertManager.shared.showAlert
        
        APIManager.shared.$apiKey
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.apiKey = newValue
            }
            .store(in: &cancellables)
        
        AlertManager.shared.$showAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newStatus in
                self?.showAlert = newStatus
            }
            .store(in: &cancellables)
        
    }
    
    func saveAPIKey() {
        APIManager.shared.saveAPIKey(apiKey: apiKey)
    }
    
    func checkApiKey() {
        _ = APIManager.shared.checkApiKey()
    }
    
   
    
}
