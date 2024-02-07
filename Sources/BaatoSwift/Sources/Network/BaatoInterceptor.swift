//
//  BaatoInterceptor.swift
//  
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//

import Foundation
import SwiftNetworking

@available(iOS 13.0, *)
@available(macOS 10.15, *)
final class BaatoInterceptor: RequestInterceptor {
    func intercept(request: inout URLRequest, router: NetworkingRouter) throws {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "Unknown"
        let sessionId = BaatoSwift.getSessionId()
        request.setValue(bundleIdentifier, forHTTPHeaderField: "BundleIdentifier")
        request.setValue(sessionId, forHTTPHeaderField: "SessionId")
        request.setValue("Application/Json", forHTTPHeaderField: "Content-Type")
    }
    
    func interceptParams(params: Parameters?) -> Parameters? {
        return params
    }
}
