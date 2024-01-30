//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation


public struct BaatoSwiftErrorModel: Codable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}


public struct BaatoSwiftError: LocalizedError {

    private let reason: String
    public let code: Int

    init(_ reason: String, code: Int = 0) {
        self.reason = reason
        self.code = code
    }

    init(_ error: Error) {
        self.reason = error.localizedDescription
        self.code = 0
    }

    public var errorDescription: String? {
        return reason
    }
}

