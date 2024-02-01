//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation

public struct BaatoLocationModel: Codable, Hashable {
    public let placeId: Int
    public  let osmId: Int
    public let name: String
    public let address: String
    public let type: String
    public let score: Double
    public let radialDistanceInKm: Double?
    
    public init(placeId: Int, osmId: Int, name: String, address: String, type: String, score: Double, radialDistanceInKm: Double? = nil) {
        self.placeId = placeId
        self.osmId = osmId
        self.name = name
        self.address = address
        self.type = type
        self.score = score
        self.radialDistanceInKm = radialDistanceInKm
    }
}
