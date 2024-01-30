//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//


import Foundation
import GEOSwift

// MARK: - Datum
public struct BaatoPlaceModel: Codable {
    
    public let placeId: Int?
    public let osmId: Int?
    public let license, name, address, type: String?
    public let centroid: Centroid
    public let tags: [String]?
    public let geometry: Geometry?
    public let score: StringOrIntType?
}

// MARK: - Centroid
public struct Centroid: Codable {
    public let lat, lon: Double

    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

public enum StringOrIntType: Codable {
    case string(String)
    case int(Int)
    case double(Double)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .string(container.decode(String.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .double(container.decode(Double.self))
            } catch DecodingError.typeMismatch {
                do {
                    self = try .int(container.decode(Int.self))
                } catch DecodingError.typeMismatch {
                    throw DecodingError.typeMismatch(StringOrIntType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
                }
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .string(let string):
            try container.encode(string)
        case .double(let double):
            try container.encode(double)
        }
    }
}

