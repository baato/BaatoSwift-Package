//
//  BaatoLocation.swift
//
//
//  Created by Mohan Singh Thagunna on 29/01/2024.
//

import Foundation
import Combine
import SwiftNetworking
import CoreLocation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public class BaatoLocation {
    var cancellable: AnyCancellable?
    
    public func search(query: String, limit: Int = 7, type: String? = nil) -> AnyPublisher<[BaatoLocationModel], Error> {
        var params: [String: Any] = ["key": BaatoNetwork.configure?.key ?? "", "q": query, "limit": limit]
        if let type = type {
            params["type"] = type
        }
 
        return Future<[BaatoLocationModel], Error> { promise in
            self.cancellable = SwiftNetworking.dataRequest(router: BaatoLocationAPI.search(params)).parse().sink { completion in
                   switch completion {
                   case .finished:
                      break
                   case .failure(let error):
                       promise(.failure(error))
                   }
               } receiveValue: { response in
                   do {
                       let data = try JSONDecoder().decode(BaatoResponseModel<[BaatoLocationModel]>.self, from: response)
                       promise(.success(data.data ?? []))
                   } catch {
                       promise(.failure(error))
                   }
               }
        }.eraseToAnyPublisher()
    }

    public func reverseGeocode(coordinate: CLLocationCoordinate2D, limit: Int = 1) -> AnyPublisher<[BaatoPlaceModel], Error> {
        let params: [String: Any] = ["key": BaatoNetwork.configure?.key ?? "", 
                                     "lat": coordinate.latitude,
                                     "lon": coordinate.longitude,
                                     "limit": limit]
        
        return Future<[BaatoPlaceModel], Error> { promise in
            self.cancellable = SwiftNetworking.dataRequest(router: BaatoLocationAPI.reverseGeocode(params)).parse().sink { completion in
                   switch completion {
                   case .finished:
                      break
                   case .failure(let error):
                       promise(.failure(error))
                   }
               } receiveValue: { response in
                   do {
                       let data = try JSONDecoder().decode(BaatoResponseModel<[BaatoPlaceModel]>.self, from: response)
                       promise(.success(data.data ?? []))
                   } catch {
                       promise(.failure(error))
                   }
               }
        }.eraseToAnyPublisher()
    }
    
    public func placeDetails(placeId: Int, limit: Int = 1) -> AnyPublisher<[BaatoPlaceModel], Error> {
        let params: [String: Any] = ["key": BaatoNetwork.configure?.key ?? "",
                                     "placeId": placeId,
                                     "limit": limit]
        
        return Future<[BaatoPlaceModel], Error> { promise in
            self.cancellable = SwiftNetworking.dataRequest(router: BaatoLocationAPI.getPlaceDetail(params)).parse().sink { completion in
                   switch completion {
                   case .finished:
                      break
                   case .failure(let error):
                       promise(.failure(error))
                   }
               } receiveValue: { response in
                   do {
                       let data = try JSONDecoder().decode(BaatoResponseModel<[BaatoPlaceModel]>.self, from: response)
                       promise(.success(data.data ?? []))
                   } catch {
                       promise(.failure(error))
                   }
               }
        }.eraseToAnyPublisher()
    }
}
