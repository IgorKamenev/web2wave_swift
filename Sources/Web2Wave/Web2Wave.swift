//
//  Web2Wave.swift
//  Web2Wave
//
//  Created by Igor Kamenev on 02.11.24.
//

import Foundation

struct Web2WaveSubscriptionStatus {
    let user_id: String
    let user_email: String
    let subscriptions: [[String: Any]]
}

class Web2Wave {
    
    @MainActor static let shared = Web2Wave()
    
    var baseURL: URL?
    var apiKey: String?
        
    func fetchSubscriptionStatus(userID: String) async -> [String: Any]? {

        assert(nil != baseURL, "You have to initialize base URL before use")
        assert(nil != apiKey, "You have to initialize apiKey before use")
        
        var urlComponents = URLComponents(url: baseURL!.appendingPathComponent("api")
                                                            .appendingPathComponent("user")
                                                            .appendingPathComponent("subscriptions"),
                                          resolvingAgainstBaseURL: false)

        urlComponents?.queryItems = [URLQueryItem(name: "user", value: userID)]

        guard let url = urlComponents?.url else {
            fatalError("Invalid URL components")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey!, forHTTPHeaderField: "api-key")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                  let responseDict = jsonObject as? [String: Any]
            else {
                print("Failed to parse subscription response")
                return nil
            }

            return responseDict
            
        } catch {
            print("Failed to fetch subscription status: \(error.localizedDescription)")
            return nil
        }
    }
    
    func hasActiveSubscription(userID: String) async -> Bool {
        
        if let subscriptionStatus = await fetchSubscriptionStatus(userID: userID) {
            
            guard let subscriptions = subscriptionStatus["subscription"] as? [[String: Any]]
            else {
                return false
            }

            let hasActiveSubscription = subscriptions.contains { subscription in
                if let status = subscription["status"] as? String, (status == "active" || status == "trialing") {
                    return true
                }
                return false
            }
            
            return hasActiveSubscription
        }
        return false
    }

    func fetchUserProperties(userID: String) async -> [String: String]? {

        assert(nil != baseURL, "You have to initialize base URL before use")
        assert(nil != apiKey, "You have to initialize apiKey before use")
        
        var urlComponents = URLComponents(url: baseURL!.appendingPathComponent("api")
                                                            .appendingPathComponent("user")
                                                            .appendingPathComponent("properties"),
                                          resolvingAgainstBaseURL: false)

        urlComponents?.queryItems = [URLQueryItem(name: "user", value: userID)]

        guard let url = urlComponents?.url else {
            fatalError("Invalid URL components")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey!, forHTTPHeaderField: "api-key")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                  let responseDict = jsonObject as? [String: Any],
                  let properties = responseDict["properties"] as? [[String: String]]
            else {
                print("Failed to parse properties response")
                return nil
            }

            let resultDict = properties.reduce(into: [String: String]()) { dict, item in
                if let key = item["property"], let value = item["value"] {
                    dict[key] = value
                }
            }
            
            return resultDict
            
        } catch {
            print("Failed to fetch properties: \(error.localizedDescription)")
            return nil
        }
    }

}
