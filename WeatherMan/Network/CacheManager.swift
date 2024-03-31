//
//  CacheManager.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 05.02.2024.
//
import Foundation
import Cache
import Combine

enum CacheError: Error {
    case storageUnavailable
}

class CacheManager {
    static let shared = CacheManager()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var savedResult: SingleLocationResult?
    @Published var suggestions: Set<String> = []
    
    private let keysStorageKey = "CachedKeys"
    
    @Published var storage3: Storage<String, Data>?
    let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("WeatherCache")

    init() {
        do {
            try FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            
            self.storage3 = try Storage(
                diskConfig: DiskConfig(name: "Floppy", expiry: .date(Date().addingTimeInterval(100)), directory: cacheDirectoryURL),
                memoryConfig: MemoryConfig(expiry: .date(Date().addingTimeInterval(100)), countLimit: 10, totalCostLimit: 10),
                transformer: TransformerFactory.forCodable(ofType: Data.self)
            )            
            loadCachedKeys()
        } catch {
            print("Error creating storage: \(error)")
        }
    }
    
    private func loadCachedKeys() {
        guard let storage = storage3 else { return }
        storage.async.object(forKey: keysStorageKey) { [weak self] result in
            switch result {
            case .value(let jsonData):
                do {
                    let keys = try JSONDecoder().decode(Set<String>.self, from: jsonData)
                    self?.suggestions = keys
                } catch {
                    print("Error decoding cached keys: \(error)")
                }
            case .error(let error):
                print("Error retrieving cached keys: \(error)")
            }
        }
    }
 
    private func saveCachedKeys() {
        guard let storage = storage3 else { return }
        do {
            let keysData = try JSONEncoder().encode(suggestions)
            try storage.setObject(keysData, forKey: keysStorageKey)
        } catch {
            print("Error saving cached keys: \(error)")
        }
    }
    
    func saveObjectToCache<T: Codable>(_ object: T, forKey key: String, expiration: Expiry = .date(Date().addingTimeInterval(10))) {
        do {
            let jsonData = try JSONEncoder().encode(object)
            try storage3?.setObject(jsonData, forKey: key, expiry: expiration)
            suggestions.insert(key)
            saveCachedKeys()
        } catch {
            print("Error saving object to cache: \(error)")
        }
    }
    
    func getObject<T: Codable>(ofType type: T.Type, forKey key: String) -> AnyPublisher<T?, Error> {
        guard let storage = storage3 else {
            return Fail(error: CacheError.storageUnavailable).eraseToAnyPublisher()
        }
        
        let subject = PassthroughSubject<T?, Error>()
        
        storage.async.object(forKey: key) { result in
            switch result {
            case .value(let jsonData):
                do {
                    let object = try JSONDecoder().decode(type, from: jsonData)
                    subject.send(object)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(error))
                }
            case .error(let error):
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func cacheClearExpired() {
        try? storage3?.removeExpiredObjects()        
        suggestions = suggestions.filter { key in
            guard let storage = storage3 else { return false }
            return (try? storage.object(forKey: key)) != nil
        }
        print("New suggestions \(suggestions)")
        saveCachedKeys()
    }
}
