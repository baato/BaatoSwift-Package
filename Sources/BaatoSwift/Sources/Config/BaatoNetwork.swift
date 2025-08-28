//
//  BaatoNetwork.swift
//
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation
import SwiftNetworking
import Combine

public struct Configuration : Codable {
    public let mode: ConfigurationMode
    public let key : String
    
    /// An optional, user-specific identifier (e.g., Firebase Instance ID).
    public var userID: String?
    
    /// The bundle identifier of the host application. This will be set automatically.
    let appID: String
    
    public init(mode: ConfigurationMode, key: String, userID: String? = nil) {
        self.mode = mode
        self.key = key
        self.userID = userID
        
        // Automatically capture the main application's bundle identifier.
        // This is a safe operation in a typical app environment.
        var appId = Bundle.main.bundleIdentifier ?? "unknown"
        appId = "iOS_\(appId)"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appID = appId + "_" + version
        } else {
            self.appID = appId
        }
    }
}

public enum ConfigurationMode : String, Codable {
    case live, test, dev
}


@available(iOS 13.0, *)
@available(macOS 10.15, *)
//struct BaatoNetwork {
//    static var configure: Configuration?
//    
//    func configure(configure: Configuration, interceptor: RequestInterceptor? = nil, adapter: ResponseAdaptable? = nil) {
//        BaatoNetwork.configure = configure
//        
//        // set the networking configuration once
//        let config = NetworkingConfiguration(baseURL: "https://api.baato.io/api/v1/", interceptor: BaatoInterceptor(), adapter: BaatoAdapter())
//        SwiftNetworking.initialize(with: config)
//    }
//}

//public class BaatoNetwork { // Changed to class to hold state
//    
//    // --- START NEW CODE ---
//    // A static, shared instance to hold our configuration.
//    public static var shared = BaatoNetwork()
//    
//    // Hold the configuration object.
//    private(set) var configuration: Configuration?
//    
//    // Private init to enforce the singleton pattern
//    private init() {}
//    // --- END NEW CODE ---
//    
//    public func configure(configuration: Configuration, interceptor: RequestInterceptor? = nil, adapter: ResponseAdaptable? = nil) {
//        self.configuration = configuration
//        
//        let config = NetworkingConfiguration(baseURL: "https://api.baato.io/api/v1/", interceptor: BaatoInterceptor(), adapter: BaatoAdapter())
//        SwiftNetworking.initialize(with: config)
//    }
//    
//    // --- NEW METHOD TO UPDATE THE USER ID ---
//    public func setUserID(_ userID: String?) {
//        self.configuration?.userID = userID
//        print("Baato SDK: User ID updated.")
//    }
//}
class BaatoNetwork { // Note: This can be an internal class
    
    // --- KEY CHANGE ---
    // A static property to hold the single configuration instance for the entire SDK.
    static var configuration: Configuration?
    
    // The initializer is now simple.
    init() {}
    
    func configure(configuration: Configuration) {
        // Store the configuration object statically.
        BaatoNetwork.configuration = configuration
        
        // set the networking configuration once
        let config = NetworkingConfiguration(baseURL: "https://api.baato.io/api/v1/", interceptor: BaatoInterceptor(), adapter: BaatoAdapter())
        SwiftNetworking.initialize(with: config)
    }
}
