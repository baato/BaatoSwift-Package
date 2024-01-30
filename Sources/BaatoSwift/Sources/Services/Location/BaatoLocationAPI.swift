//
//  LocationAPI.swift
//
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//


import Foundation
import SwiftNetworking

enum BaatoLocationAPI: NetworkingRouter {
   
    case search(Parameters)
    case reverseGeocode(Parameters)
    case getPlaceDetail(Parameters)
    case styles(Parameters)
    
     var path: String {
        switch self {
        case .search:
            return "search"
        case .reverseGeocode:
            return "reverse"
        case .getPlaceDetail:
            return "places"
        case .styles:
            return "styles"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search,
         .reverseGeocode,
         .getPlaceDetail,
         .styles:
            return .get
        }
    }
    
    var encoder: [EncoderType] {
        switch self {
        case .search(let params),
         .reverseGeocode(let params),
         .getPlaceDetail(let params),
         .styles(let params):
            return [.url(params)]
        }
    }
    
}

