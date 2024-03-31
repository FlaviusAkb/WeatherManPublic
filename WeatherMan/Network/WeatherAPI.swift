//
//  WeatherAPI.swift
//  WeatherMan
//
//  Created by Flavius Ilie on 30.01.2024.
//

import Combine
import Foundation


enum APIError: Error {
    case invalidData
}
@MainActor
class WeatherAPI {
    func getWeatherFor(_ location: String) -> AnyPublisher<SingleLocationResult, Error> {
        if CacheManager.shared.suggestions.contains(location) {
            return CacheManager.shared.getObject(ofType: SingleLocationResult.self, forKey: location)
                .map { cachedResult in
                    print("result from cache")
                    return cachedResult ?? SingleLocationResult.defaultResponse
                }
                .eraseToAnyPublisher()
        } else {
            return Future<SingleLocationResult, Error> { promise in
                NetworkManager.shared.loadData(endpoint: .getSingleLocationData(for: location)) { response in
                    if let data = response.data {
                        do {
                            let result = try JSONDecoder().decode(SingleLocationResult.self, from: data)
                            CacheManager.shared.saveObjectToCache(result, forKey: location)
                            print("result from server, saved to cache")
                            promise(.success(result))
                        } catch {
                            promise(.failure(error))
                        }
                    } else {
                        promise(.failure(APIError.invalidData))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    }
}
