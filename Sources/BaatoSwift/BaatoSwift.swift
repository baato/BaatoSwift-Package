// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftNetworking
import Combine

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct BaatoSwift {
    
    private static var `default` = BaatoSwift()
    private init() {}
    
    static let network: BaatoNetwork = BaatoNetwork()
    
    //MARK: - Public Properties
    public static let location = BaatoLocation()
    public static let navigation = BaatoNavigation()

    public static func configure(configure: Configuration) {
        network.configure(configure: configure)
    }
    
}
