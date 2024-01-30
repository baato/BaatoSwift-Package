//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation
import SwiftNetworking
import Combine

struct Parser {

    // The networkingResponse received
    private let response: NetworkingResponse?

    init(response: NetworkingResponse?) {
        self.response = response
    }

    // parse the data from response
    func parse() throws {
        guard let response = response, let urlResponse = response.urlResponse as? HTTPURLResponse else {
            throw BaatoSwiftError("Something went wrong. Please try again later")
        }
       
        guard !(200...299 ~= urlResponse.statusCode) else { return }

            let errorModel = try JSONDecoder().decode(BaatoSwiftErrorModel.self, from: response.data)
            if urlResponse.statusCode == 401 {
                throw BaatoSwiftError(errorModel.message, code: urlResponse.statusCode)
            }
            throw BaatoSwiftError(errorModel.message, code: urlResponse.statusCode)

    }
}


// decode helper extension
@available(iOS 13.0, *)
extension Publisher where Output == Data {
    @available(iOS 13.0, *)
    public func decode<T>(_ type: T.Type) -> Publishers.Decode<Self, T, JSONDecoder> {
        decode(type: T.self, decoder: JSONDecoder())
    }
}

// parse helper
@available(iOS 13.0, *)
extension Publisher where Output == NetworkingResponse {
    @available(iOS 13.0, *)
    public func parse() -> AnyPublisher<Data, Error> {
        return mapError { apiError -> Error in
            guard let error = apiError as? NetworkingError else { return BaatoSwiftError(apiError) }
            do {
                if let response = error.networkingResponse(), response.urlResponse != nil {
                    try Parser(response: response).parse()
                    return BaatoSwiftError(error)
                } else {
                    return BaatoSwiftError(error)
                }

            } catch {
                return BaatoSwiftError(error)
            }
        }.tryMap { response -> NetworkingResponse in
            try Parser(response: response).parse()
            return response
        }.map(\.data).eraseToAnyPublisher()
    }
}
