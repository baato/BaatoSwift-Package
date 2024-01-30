//
//  File.swift
//
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//

import Foundation
import SwiftNetworking
import Combine

@available(iOS 13.0, *)
final class BaatoAdapter: ResponseAdaptable {
    
    func adapt(router: NetworkingRouter, error: NetworkingError) throws -> AnyPublisher<NetworkingResponse, NetworkingError> {
        throw error
    }
    
    func adapt(router: NetworkingRouter, response: NetworkingResponse) {
        
    }
    
    
}
