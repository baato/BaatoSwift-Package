//
//  File.swift
//
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//


import Foundation

public struct BaatoNavigationModel: Codable {
    public let routeWight: Double?
    public let distanceInMeters: Double
    public let encodedPolyline: String
    public let timeInMs: CLong
    public let instructionList: [BaatoInstruction]?
    
}

public struct BaatoInstruction: Codable {
    public let sign: Int
    public let name: String
    public let distance: Double
    public let time: Int
    public let length: Int
    public var points: BaatoInstructionPoint?
    public var annotation: BaatoInstructionAnnotation?
    public var extraInfoJSON: [String: BaatoCodableValue]?
    
    // Define enum for coding keys
        private enum CodingKeys: String, CodingKey {
            case sign, name, distance, time, length, points, annotation, extraInfoJSON
            // Add other coding keys for your other properties if needed
        }
}

public struct BaatoInstructionPoint: Codable {
    public let size: Int
    public let intervalString: String
    public let immutable: Bool
//    public let threeDimention: Bool
    public let dimension: Int
    public let empty: Bool
}

public struct BaatoInstructionAnnotation: Codable {
    public let empty: Bool
    public let importance: Int
    public let message: String
}

public struct ExtraInfo: Codable {
    public let empty: Bool
    public let importance: Int
    public let message: String
}

// Define a wrapper type that conforms to Codable and represents any Codable type
public enum BaatoCodableValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case dictionary([String: BaatoCodableValue])
    case array([BaatoCodableValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: BaatoCodableValue].self) {
            self = .dictionary(value)
        } else if let value = try? container.decode([BaatoCodableValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid CodableValue"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        }
    }
}
