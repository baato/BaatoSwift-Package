//
//  BaatoInterceptor.swift
//  
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//

import Foundation
import SwiftNetworking

final class BaatoInterceptor: RequestInterceptor {
    func intercept(request: inout URLRequest, router: NetworkingRouter) throws {
        request.setValue("Application/Json", forHTTPHeaderField: "Content-Type")
    }
    
    func interceptParams(params: Parameters?) -> Parameters? {
        return params
    }
}
