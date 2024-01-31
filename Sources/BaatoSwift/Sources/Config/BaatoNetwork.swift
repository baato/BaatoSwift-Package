//
//  BaatoNetwork.swift
//
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation
import SwiftNetworking
import Combine

public struct Configuration : Decodable {
    let mode: ConfigurationMode
    let key : String
}

public enum ConfigurationMode : String, Decodable {
    case live, test, dev
}


@available(iOS 13.0, *)
@available(macOS 10.15, *)
struct BaatoNetwork {
    static var configure: Configuration?
    
    func configure(configure: Configuration, interceptor: RequestInterceptor? = nil, adapter: ResponseAdaptable? = nil) {
        BaatoNetwork.configure = configure
        
        // set the networking configuration once
        let config = NetworkingConfiguration(baseURL: "https://api.baato.io/api/v1/", interceptor: BaatoInterceptor(), adapter: BaatoAdapter())
        SwiftNetworking.initialize(with: config)
    }
}

