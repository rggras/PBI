//
//  NetworkManager.swift
//  PBI
//
//  Created by Rodrigo Gras on 11/8/17.
//  Copyright © 2017 GlobalLogic, Inc. All rights reserved.
//

import Foundation
import PersistenceManager

let PBIVehiclesEndpoint = "/api/vehicles?includeCurrentTrips=true"
let PBITripHistoryEndpoint = "/api/trips/history"
let PBIGetPolicyEndpoint = "/api/policies/%@"
let PBICancelPolicyEndpoint = "/api/policies/%@/cancel"

class NetworkManager {
    
    var network = PersistenceManager.NetworkStrategy()
    
    func getUrlRequestWithEndpoint(endpoint: String) -> URLRequest {
        
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: PBIBaseUrl) as? String ?? ""
        var urlRequest = URLRequest(url: URL(string: baseUrl + endpoint)!)
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: PBIAccessToken) {
            urlRequest.addValue("Bearer  \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    func getUrlRequestWithEndpoint(endpoint: String, httpMethod: String) -> URLRequest {
     
        var urlRequest = self.getUrlRequestWithEndpoint(endpoint: endpoint)
        urlRequest.httpMethod = httpMethod
        
        return urlRequest
    }
    
    // MARK: - Vehicles
    
    func getVehicles(completion: @escaping (_ response: [Vehicle]?, _ error: PMError?) -> Void) {
        
        let urlRequest = self.getUrlRequestWithEndpoint(endpoint: PBIVehiclesEndpoint)
        let getObject = AccessObjectStrategy<[Vehicle]>(URL: urlRequest)
        
        network.getData(getObject, success: { (items: [Vehicle]) in
        
            completion(items, nil)
            
        }, failure: { (e: PMError) in
        
            completion(nil, e)
            
        })
    }
    
    // MARK: - Trips
    
    func getTripHistory(completion: @escaping (_ response: [Trip]?, _ error: PMError?) -> Void) {
        
        let urlRequest = self.getUrlRequestWithEndpoint(endpoint: PBITripHistoryEndpoint)
        let getObject = AccessObjectStrategy<[Trip]>(URL: urlRequest)
        
        network.getData(getObject, success: { (items: [Trip]) in
            
            completion(items, nil)
            
        }, failure: { (e: PMError) in
            
            completion(nil, e)
            
        })
    }
    
    // MARK: - Policy
    
    func getPolicy(policyId: String, completion: @escaping (_ response: Policy?, _ error: PMError?) -> Void) {
        
        let endpoint = String(format: PBIGetPolicyEndpoint, policyId)
        let urlRequest = self.getUrlRequestWithEndpoint(endpoint: endpoint)
        let getObject = AccessObjectStrategy<Policy>(URL: urlRequest)
        
        network.getData(getObject, success: { (item: Policy) in
            
            completion(item, nil)
            
        }, failure: { (e: PMError) in
            
            completion(nil, e)
            
        })
    }
    
    func cancelPolicy(policyId: String, completion: @escaping (_ response: Policy?, _ error: PMError?) -> Void) {
        
        let endpoint = String(format: PBICancelPolicyEndpoint, policyId)
        let urlRequest = self.getUrlRequestWithEndpoint(endpoint: endpoint, httpMethod: "POST")
        let getObject = AccessObjectStrategy<Policy>(URL: urlRequest)
        
        network.getData(getObject, success: { (item: Policy) in
            
            completion(item, nil)
            
        }, failure: { (e: PMError) in
            
            completion(nil, e)
            
        })
    }
}
