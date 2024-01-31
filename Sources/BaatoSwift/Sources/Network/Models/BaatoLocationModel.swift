//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation

public struct BaatoLocationModel: Codable {
    public let placeId: Int
    public  let osmId: Int
    public let name: String
    public let address: String
    public let type: String
    public let score: Double
    public let radialDistanceInKm: Double
}