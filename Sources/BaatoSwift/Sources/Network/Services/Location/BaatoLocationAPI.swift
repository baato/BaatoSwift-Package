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
    case nearBy(Parameters)
    
     var path: String {
        switch self {
        case .search:
            return "search"
        case .reverseGeocode:
            return "reverse"
        case .getPlaceDetail:
            return "places"
        case .nearBy:
            return "search/nearby"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search,
         .reverseGeocode,
         .getPlaceDetail,
         .nearBy:
            return .get
        }
    }
    
    var encoder: [EncoderType] {
        switch self {
        case .search(let params),
         .reverseGeocode(let params),
         .getPlaceDetail(let params),
         .nearBy(let params):
            return [.url(params)]
        }
    }
    
}

