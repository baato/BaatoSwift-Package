//
//  File.swift
//  
//
//  Created by Mohan Singh Thagunna on 30/01/2024.
//


import Foundation
import Combine
import SwiftNetworking
import CoreLocation

public enum BaatoNavigationMode: String {
    case car, bike, foot, transit, none
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class BaatoNavigation {
    var cancellable: AnyCancellable?
    
    public func directions(points: [CLLocationCoordinate2D], mode: BaatoNavigationMode, isInstructionEnable: Bool = false) -> AnyPublisher<[BaatoNavigationModel], Error> {
        let arrayPoints = points.map({"\($0.latitude),\($0.longitude)"})
        let params: [String: Any] = ["key": BaatoNetwork.configure?.key ?? "", "points": arrayPoints, "mode": mode, "instructions": isInstructionEnable]
 
        return Future<[BaatoNavigationModel], Error> { promise in
            self.cancellable = SwiftNetworking.dataRequest(router: BaatoNavigationAPI.directions(params)).parse().sink { completion in
                   switch completion {
                   case .finished:
                      break
                   case .failure(let error):
                       promise(.failure(error))
                   }
               } receiveValue: { response in
                   do {
                       let data = try JSONDecoder().decode(BaatoResponseModel<[BaatoNavigationModel]>.self, from: response)
                       promise(.success(data.data ?? []))
                   } catch {
                       promise(.failure(error))
                   }
               }
        }.eraseToAnyPublisher()
    }
}

