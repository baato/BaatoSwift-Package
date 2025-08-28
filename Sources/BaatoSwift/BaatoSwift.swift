// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftNetworking
import Combine
import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct BaatoSwift {
    
    private static var `default` = BaatoSwift()
    private init() {}
    
    static let network: BaatoNetwork = BaatoNetwork()
    
    //MARK: - Public Properties
    public static let location = BaatoLocation()
    public static let navigation = BaatoNavigation()
    public static let map = BaatoMap()

    public static func configure(configure: Configuration) {
        network.configure(configuration: configure)
    }
    
    public static func getSessionId() -> String {
        if let savedId = UserDefaults.standard.string(forKey: "baato-session-id") {
            return savedId
        } else {
            let newSessionId = UUID().uuidString
            UserDefaults.standard.setValue(newSessionId, forKey: "baato-session-id")
            UserDefaults.standard.synchronize()
            return newSessionId
        }
    }
    
    /// Updates the user identifier for all subsequent API requests.
      /// Call this after the initial `configure` call, once you have obtained a user-specific ID.
      /// - Parameter userID: The user identifier string, or nil to remove it.
      public static func setUserID(_ userID: String?) {
          // This safely updates the userID on the statically stored configuration object.
          BaatoNetwork.configuration?.userID = userID
          print("BaatoSwift: User ID has been updated.")
      }
}
