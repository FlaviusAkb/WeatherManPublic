//
//  APIManager.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 22.12.2023.
//
import Firebase
import FirebaseRemoteConfig
import Foundation

class APIManager {
    
    static let shared = APIManager()
    @Published var isApiPresented: Bool = false
    @Published var apiKey: String
    
    var remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    var localKey: String = UserDefaults.standard.string(forKey: "apiKey") ?? ""
    
    init() {
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        apiKey = self.remoteConfig.defaultValue(forKey: "apiKey")?.stringValue ?? localKey
    }
    
    
    func saveAPIKey(apiKey: String) {
        self.apiKey = apiKey
        UserDefaults.standard.set(apiKey, forKey: "apiKey")
        print("ApiKey saved: \(apiKey)")
    }
    
    func checkApiKey() -> Bool {
        let savedAPIKey = apiKey
        
        if savedAPIKey.isEmpty {
            print("API Key is empty or incomplete")
            AlertManager.shared.showAlert(title: "Error", message: "API Key is empty or wrong.(\(savedAPIKey.count) characters.)")
            isApiPresented = false
            return false
        } else {
            Task {
                do {
                    let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(savedAPIKey)&q=London&aqi=no")!
                    
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    // Check if the response status code indicates an error
                    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                        // Handle HTTP error
                        print("HTTP error: \(httpResponse.statusCode)")
                        AlertManager.shared.showAlert(title: "Error", message: "HTTP error: \(httpResponse.statusCode)")
                        isApiPresented = false
                        return false
                    }
                    
                    let decoder = JSONDecoder()
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    
                    // Check if the error code and message match your criteria
                    if let error = errorResponse.error, error.code == 2008 && error.message == "API key has been disabled." {
                        AlertManager.shared.showAlert(title: "Error", message: "API key has been disabled.")
                        print("API key has been disabled.")
                        // Handle this specific error case here
                        isApiPresented = false
                        return false
                    } else {
                        AlertManager.shared.showAlert(title: "Connected", message: "API request successful")
                        // Continue with handling other cases or success
                        print("API request successful")
                        isApiPresented = true
                        return true
                    }
                } catch {
                    AlertManager.shared.showAlert(title: "Error", message: "Error during API request: \(error)")
                    // Handle other errors or invalid JSON
                    print("Error during API request: \(error)")
                    isApiPresented = false
                    return false
                }
            }
        }
        return false
    }
    
    func updateKey() {
        remoteConfig.fetch { [self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                remoteConfig.activate { changed, error in
                    if let loadedKey = self.remoteConfig.configValue(forKey: "apiKey").stringValue {
                        print("Fetched API Key: \(loadedKey)")
                        self.saveAPIKey(apiKey: loadedKey)
                    } else {
                        print("Failed to load API Key from Remote Config")
                    }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}
