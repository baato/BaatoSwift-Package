//
//  Untitled.swift
//  BaatoSwift
//
//  Created by Bhawak Pokhrel on 27/08/2025.
//

import Foundation

/// A configuration object that defines the behavior of the Baato SDK.
public struct BaatoConfiguration {
    
    /// Your Baato API access token.
    let accessToken: String
    
    /// An optional, user-specific identifier.
    /// This could be an internal user ID, a Firebase Instance ID, etc.
    /// If provided, it will be sent with API requests to help identify user-specific actions.
    let userID: String?
    
    /// Initializes a new configuration object.
    /// - Parameters:
    ///   - accessToken: Your Baato API access token. Required.
    ///   - userID: An optional, user-specific identifier. Defaults to nil.
    public init(accessToken: String, userID: String? = nil) {
        self.accessToken = accessToken
        self.userID = userID
    }
}
