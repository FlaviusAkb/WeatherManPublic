//
//  NetworkManager.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 23.12.2023.
//


import Alamofire
import Foundation

class APIResponse: Codable {
    var code: Int?
    var data: Data?
    var message: String?
}

enum HttpStatusCodeEnum {
    case success
    case unauthorized
    case badRequestQNotProvided
    case badRequestInvalidUrl
    case badRequestNoLocationFound
    case unauthorizedInvalidApiKey
    case forbiddenCallsQuotaExceeded
    case forbiddenApiKeyDisabled
    case forbiddenNoResourceAccess
    case badRequestInvalidJsonBody
    case badRequestTooManyLocations
    case internalError
    
    var statusCode: Int {
        switch self {
        case .success: return 200
        case .unauthorized: return 401
        case .badRequestQNotProvided, .badRequestInvalidUrl, .badRequestNoLocationFound, .badRequestInvalidJsonBody, .badRequestTooManyLocations, .internalError:
            return 400
        case .unauthorizedInvalidApiKey, .forbiddenCallsQuotaExceeded, .forbiddenApiKeyDisabled, .forbiddenNoResourceAccess:
            return 403
        }
    }
    
    var errorCode: Int {
        switch self {
        case .success: return 0
        case .unauthorized: return 1002
        case .badRequestQNotProvided: return 1003
        case .badRequestInvalidUrl: return 1005
        case .badRequestNoLocationFound: return 1006
        case .unauthorizedInvalidApiKey: return 2006
        case .forbiddenCallsQuotaExceeded: return 2007
        case .forbiddenApiKeyDisabled: return 2008
        case .forbiddenNoResourceAccess: return 2009
        case .badRequestInvalidJsonBody: return 9000
        case .badRequestTooManyLocations: return 9001
        case .internalError: return 9999
        }
    }
    
    var description: String {
        switch self {
        case .success: return "Success"
        case .unauthorized: return "API key not provided."
        case .badRequestQNotProvided: return "Parameter 'q' not provided."
        case .badRequestInvalidUrl: return "API request URL is invalid."
        case .badRequestNoLocationFound: return "No location found matching parameter 'q'."
        case .unauthorizedInvalidApiKey: return "API key provided is invalid."
        case .forbiddenCallsQuotaExceeded: return "API key has exceeded calls per month quota."
        case .forbiddenApiKeyDisabled: return "API key has been disabled."
        case .forbiddenNoResourceAccess: return "API key does not have access to the resource. Please check the pricing page for what is allowed in your API subscription plan."
        case .badRequestInvalidJsonBody: return "Json body passed in bulk request is invalid. Please make sure it is valid JSON with utf-8 encoding."
        case .badRequestTooManyLocations: return "Json body contains too many locations for bulk request. Please keep it below 50 in a single request."
        case .internalError: return "Internal application error."
        }
    }
    
    static func fromStatusCode(_ statusCode: Int) -> HttpStatusCodeEnum? {
        switch statusCode {
        case 200: return .success
        case 401: return .unauthorized
        case 400: return .badRequestQNotProvided
        case 403: return .unauthorizedInvalidApiKey
        default:
            return nil
        }
    }
}
@MainActor
class NetworkManager {
    
    static let shared = NetworkManager()
    
    init() {}
    
    func loadData(endpoint: Endpoint, completion: @escaping (APIResponse) -> Void) {
        AF.request(
            endpoint.url,
            method: endpoint.method,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            interceptor: nil
        )
        .response { resp in
            guard self.httpCodeCheck(resp.response, for: endpoint) else {
                print("httpCodeCheck fail")
                return
            }
            //            dump(resp.request)
            switch resp.result {
            case let .success(data):
                if let decodedResult = self.decode(data), self.isValid(decodedResult) {
                    decodedResult.data = data
                    completion(decodedResult)
                }
            case let .failure(error):
                AlertManager.shared.showAlert(title: "Network fail",
                                              message: error.localizedDescription)
            }
        }
    }
    
    private func decode(_ data: Data?) -> APIResponse? {
        do {
            return try JSONDecoder().decode(APIResponse.self, from: data!)
        } catch let error {
            AlertManager.shared.showAlert(title: "Decode error",
                                          message: error.localizedDescription)
            return nil
        }
    }
    
    private func isValid(_ apiResponse: APIResponse) -> Bool {
        guard let message = apiResponse.message else { return true }
        AlertManager.shared
            .showAlert(title: "Network error",
                       message: message)
        return false
    }
    
    
    private func httpCodeCheck(_ response: HTTPURLResponse?, for endpoint: Endpoint) -> Bool {
        guard let httpStatusCode = response?.statusCode else {
            let errorMessage = "HTTP Status Code is missing."
            showAlert(for: endpoint, message: errorMessage)
            return false
        }
        
        guard let httpStatusCodeEnum = HttpStatusCodeEnum.fromStatusCode(httpStatusCode) else {
            let errorMessage = "Unknown HTTP Status Code: \(httpStatusCode)"
            showAlert(for: endpoint, message: errorMessage)
            return false
        }
        
        if httpStatusCodeEnum == .success {
            return true
        } else {
            let errorMessage = "Error: \(httpStatusCodeEnum.errorCode) \(httpStatusCodeEnum.description)"
            if endpoint.displayErrors {
                showAlert(for: endpoint, message: errorMessage)
            }
            
            return false
        }
    }
    private func showAlert(for endpoint: Endpoint, message: String) {
        if endpoint.displayErrors {
            AlertManager.shared.showAlert(title: "Network error", message: message)
        }
    }
}
