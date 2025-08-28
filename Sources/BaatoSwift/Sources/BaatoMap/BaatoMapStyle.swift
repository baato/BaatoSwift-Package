//
//  BaatoMapStyle.swift
//
//
//  Created by Mohan Singh Thagunna on 31/01/2024.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public enum BaatoMapStyle: String {
    case breeze = "Breeze"
    case monochrome = "Monochrome"
    case retro = "Retro"
    case outdoor = "Outdoor"
    case night = "Dark"
    case satellite = "Satellite"
    
    public var url: URL? {
        let key = BaatoNetwork.configuration?.key ?? ""
        let baseUrl = "https://api.baato.io/api/v1/styles/"
        switch self {
        case .satellite:
            return nil
        default:
            return URL(string: "\(baseUrl)\(self.rawValue.lowercased())?key=\(key)")
        }
    }
}
