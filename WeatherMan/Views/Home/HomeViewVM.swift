//
//  HomeViewVM.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 19.12.2023.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var displayedDTO: WeatherDataDTO = WeatherDataDTO(result: SingleLocationResult.defaultResponse, isCelsius: true)
    @Published var selectedOption: String = "Example City"
    @Published var suggestions: Set<String>
    @Published var showAlert: Bool
    @Published var isApiPresented: Bool
    @Published var alertMessage: String
    @Published var searchText: String = ""
    @Published var searchClosed: Bool = false
    
    @Published var weatherSubmit: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
            displayedDTO = WeatherDataDTO(result: SingleLocationResult.defaultResponse, isCelsius: true)
            suggestions = CacheManager.shared.suggestions
            showAlert = AlertManager.shared.showAlert
            isApiPresented = APIManager.shared.isApiPresented
            alertMessage = AlertManager.shared.alertMessage        
        
        self.$weatherSubmit
            .map { _ in self.searchText}
            .filter { searchText in
                   !searchText.isEmpty
            }
            .flatMap { text in WeatherAPI().getWeatherFor(text) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in }) { [weak self] result in
                self?.displayedDTO = WeatherDataDTO(result: result, isCelsius: true)
                self?.selectedOption = result.location?.name ?? "Example City"
            }
            .store(in: &cancellables)

            AlertManager.shared.$showAlert
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newStatus in
                    self?.showAlert = newStatus
                }
                .store(in: &cancellables)
        }
    
    func submitLocation(text: String) {
        print("Text: \(text)")
        guard text != "Example City" && !text.isEmpty else { return }
            searchText = text
            weatherSubmit.toggle()
            print("updated")
            searchClosed = false
        
    }

}
