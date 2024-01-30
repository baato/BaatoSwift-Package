//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//


import Foundation
import SwiftNetworking

enum BaatoNavigationAPI: NetworkingRouter {

    case directions(Parameters)
    
   var path: String {
        switch self {
        case .directions:
            return "directions"
        }
    }
    
   var httpMethod: HTTPMethod {
        switch self {
        case .directions:
            return .get
        }
    }
    
   var encoder: [EncoderType] {
        switch self {
        case .directions(let params):
            return [.url(params)]
        }
    }
    
}

