//
//  WebClient.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/26/18.
//  Copyright © 2018 markw. All rights reserved.
//

import Foundation

typealias responseBlock = (_ responseData: Data?, _ errorMessage: String?) -> ()

protocol FetchClient {
    
    func fetch(withUrlPath urlPath: String, withCompletion: @escaping responseBlock)
}

struct WebClient : FetchClient {
    
    let noConnectionAvailable = "No connection available."
    let invalidUrlPath = "could not create url from given path"
    let serverErrorMessage = "something on the server went wrong"
    
    func fetch(withUrlPath urlPath: String, withCompletion completion: @escaping responseBlock) {
        
        if ConnectionManager.shared.isNetworkAvailable == false {
            completion(nil, noConnectionAvailable)
        }
        
        guard let url = URL(string: urlPath) else {
            completion(nil, invalidUrlPath)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let validData = data, error == nil else {
                    completion(nil, error?.localizedDescription)
                    return
                }
                
                if let http = response as? HTTPURLResponse {
                    if http.statusCode != 200 {
                        completion(nil, self.serverErrorMessage)
                    } else {
                        completion(validData, nil)
                    }
                }
            }
            
            }.resume()
    }
}
