//
//  ConnectionManager.swift
//  DealFinder
//
//  Created by Mark Wilkinson on 9/26/18.
//  Copyright © 2018 markw. All rights reserved.
//
//  An easy-to-use wrapper for Ashley Mills' Reachability class

import Foundation

class ConnectionManager {
    
    static let shared = ConnectionManager()
    
    let reachability = Reachability()!
    
    var isNetworkAvailable : Bool {
        return reachability.connection != .none
    }
}
