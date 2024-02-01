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
    
    public init(routeWight: Double?, distanceInMeters: Double, encodedPolyline: String, timeInMs: CLong, instructionList: [BaatoInstruction]?) {
        self.routeWight = routeWight
        self.distanceInMeters = distanceInMeters
        self.encodedPolyline = encodedPolyline
        self.timeInMs = timeInMs
        self.instructionList = instructionList
    }
    
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
    
    public init(sign: Int, name: String, distance: Double, time: Int, length: Int, points: BaatoInstructionPoint? = nil, annotation: BaatoInstructionAnnotation? = nil, extraInfoJSON: [String : BaatoCodableValue]? = nil) {
        self.sign = sign
        self.name = name
        self.distance = distance
        self.time = time
        self.length = length
        self.points = points
        self.annotation = annotation
        self.extraInfoJSON = extraInfoJSON
    }
}

public struct BaatoInstructionPoint: Codable {
    public let size: Int
    public let intervalString: String
    public let immutable: Bool
//    public let threeDimention: Bool
    public let dimension: Int
    public let empty: Bool
    
    public init(size: Int, intervalString: String, immutable: Bool, dimension: Int, empty: Bool) {
        self.size = size
        self.intervalString = intervalString
        self.immutable = immutable
        self.dimension = dimension
        self.empty = empty
    }
}

public struct BaatoInstructionAnnotation: Codable {
    public let empty: Bool
    public let importance: Int
    public let message: String
    
    public init(empty: Bool, importance: Int, message: String) {
        self.empty = empty
        self.importance = importance
        self.message = message
    }
}

public struct ExtraInfo: Codable {
    public let empty: Bool
    public let importance: Int
    public let message: String
    
    public init(empty: Bool, importance: Int, message: String) {
        self.empty = empty
        self.importance = importance
        self.message = message
    }
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
