//
//  StorageManager.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 22.12.2023.
//
import Combine
import Foundation

enum SaveResultsError: Error {
    case noLocationFound
    case encodingError(Error)
    case unknownError

    var localizedDescription: String {
        switch self {
        case .noLocationFound:
            return "No location found in results."
        case .encodingError(let error):
            return "Error encoding results: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
//
//@MainActor
//class StorageManager {
//    
//    static let shared = StorageManager()
//    
//    private var cancellables: Set<AnyCancellable> = []
//    
//    @Published var results: [SingleLocationResult] = []
//    @Published var selectedOption: String = "Search for a city"
//    @Published var suggestions: [String] = []
//    
//    @Published var storedData = [:]
//    
//    init() {
//        suggestions = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
//        initializeResults()
//    }
//    
//    private func initializeResults() {
////        if let savedResultsData = UserDefaults.standard.data(forKey: "savedResults") {
////            do {
////                let decodedResults = try JSONDecoder().decode([SingleLocationResult].self, from: savedResultsData)
////                updateDisplayedResults(decodedResults)
////            } catch {
////                print("Error decoding savedResults data as array of Result: \(error)")
////                AlertManager.shared.showAlert(title: "Error", message: "Error decoding savedResults data as array of Result: \(error)")
////                // If decoding as an array fails, try decoding as a single Result
////                do {
////                    let decodedResult = try JSONDecoder().decode(SingleLocationResult.self, from: savedResultsData)
////                    updateDisplayedResults([decodedResult])
////                } catch {
////                    print("Error decoding savedResults data as single Result: \(error)")
////                    AlertManager.shared.showAlert(title: "Error", message: "Error decoding savedResults data as single Result: \(error)")
////                    // If both decoding attempts fail, set results to an empty array
////                    results = []
////                }
////            }
////        }
//    }
//
////    func saveResultsToUserDefaults(_ results: [SingleLocationResult], timestamp: String) throws {
////        do {
////            guard let location = results.first?.location?.name else {
////                throw SaveResultsError.noLocationFound
////            }
////
////            var existingData = UserDefaults.standard.dictionary(forKey: "savedResults") ?? [:]
////
////            // Encode SingleLocationResult instances into JSON Data
////            let encoder = JSONEncoder()
////            encoder.outputFormatting = .prettyPrinted
////            let encodedResults = try results.map { try encoder.encode($0) }
////
////            // Check if the location already has saved results
////            if var locationData = existingData[location] as? [String: Any] {
////                // If yes, update the timestamp and results for the location
////                locationData["timestamp"] = timestamp
////                locationData["results"] = encodedResults
////                existingData[location] = locationData
////            } else {
////                // If not, create a new entry for the location
////                let resultsDict: [String: Any] = ["timestamp": timestamp, "results": encodedResults]
////                existingData[location] = resultsDict
////            }
////
////            // Limit the dictionary to only store information for up to 3 locations
////            let sortedLocations = existingData.keys.sorted(by: { $0 < $1 })
////            if sortedLocations.count > 3 {
////                if let locationToRemove = sortedLocations.first {
////                    existingData.removeValue(forKey: locationToRemove)
////                }
////            }
////
////            UserDefaults.standard.set(existingData, forKey: "savedResults")
////            print("Results saved to UserDefaults")
////            print("Results saved to UserDefaults: \(existingData)")
////
////        } catch SaveResultsError.noLocationFound {
////            print("Error: \(SaveResultsError.noLocationFound.localizedDescription)")
////            throw SaveResultsError.noLocationFound
////        } catch {
////            print("Unexpected error: \(error.localizedDescription)")
////            throw SaveResultsError.unknownError
////        }
////    }
//
//
//    func saveResultsToUserDefaults(_ results: [SingleLocationResult], timestamp: String) throws {
//        
////        CacheManager.shared.saveResultsToCache(results)
//        
////        do {
////            guard let location = results.first?.location?.name else {
////                throw SaveResultsError.noLocationFound
////            }
////
////            var existingData = UserDefaults.standard.dictionary(forKey: "savedResults") as? [String: [String: Any]] ?? [:]
////
////            // Encode SingleLocationResult instances into JSON Data
////            let encoder = JSONEncoder()
////            encoder.outputFormatting = .prettyPrinted
////            let encodedResults = try results.map { try encoder.encode($0) }
////
////            // Check if the location already has saved results
////            if var locationData = existingData[location] {
////                // If yes, update the timestamp and results for the location
////                locationData["timestamp"] = timestamp
////                locationData["results"] = encodedResults
////                existingData[location] = locationData
////            } else {
////                // If not, create a new entry for the location
////                let resultsDict: [String: Any] = ["timestamp": timestamp, "results": encodedResults]
////                existingData[location] = resultsDict
////            }
////
////            // Sort the dictionary based on timestamp
////            let sortedEntries = existingData.sorted { $0.value["timestamp"] as? String ?? "" < $1.value["timestamp"] as? String ?? "" }
////
////            // Remove the oldest entry
////            if sortedEntries.count > 3 {
////                let oldestLocation = sortedEntries.first?.key
////                existingData.removeValue(forKey: oldestLocation!)
////            }
////
////            UserDefaults.standard.set(existingData, forKey: "savedResults")
////            print("Results saved to UserDefaults")
////            print("Results saved to UserDefaults: \(existingData.keys)")
////
////        } catch SaveResultsError.noLocationFound {
////            print("Error: \(SaveResultsError.noLocationFound.localizedDescription)")
////            throw SaveResultsError.noLocationFound
////        } catch {
////            print("Unexpected error: \(error.localizedDescription)")
////            throw SaveResultsError.unknownError
////        }
//    }
//
//
//
//
//    
//    func updateRecentSearches(_ newSearchText: String) {
//        if !newSearchText.isEmpty {
//            if suggestions.contains(newSearchText) { return }
//            else {
//                if suggestions.count > 3 {
//                    suggestions.removeLast()
//                }
//                suggestions.insert(newSearchText, at: 0)
//            }
//            if suggestions.count > 3 {
//                suggestions = Array(suggestions.prefix(3))
//            }
//            UserDefaults.standard.set(suggestions, forKey: "recentSearches")
//        }
//        print("These are the cities after update: \(suggestions)")
//    }
//    
//    func updateDisplayedResults(_ newResults: [SingleLocationResult]) {
//        results = newResults
//        storedData = UserDefaults.standard.dictionary(forKey: "savedResults") as? [String: [String: Any]] ?? [:]
//        
//        selectedOption = results.first?.location?.name ?? "Search for a city"
//    }
//}
