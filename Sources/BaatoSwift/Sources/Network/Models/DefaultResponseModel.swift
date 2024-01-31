//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//

import Foundation

public struct BaatoResponseModel<T: Codable>: Codable {
    public let data: T?
    public let message: String
}
