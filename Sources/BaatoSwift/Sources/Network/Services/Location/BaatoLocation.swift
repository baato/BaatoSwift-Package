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
    var bag = Set<AnyCancellable>()
    
    public func search(query: String, limit: Int = 7, type: String? = nil, radius: Int? = nil, userCoordinate: CLLocationCoordinate2D? = nil) -> AnyPublisher<[BaatoLocationModel], Error> {
        var params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "", "q": query, "limit": limit]
        if let type = type {
            params["type"] = type
        }
        
        if let radius = radius {
            params["radius"] = radius
        }
        
        if let userCoordinate = userCoordinate {
            params["lat"] = userCoordinate.latitude
            params["lon"] = userCoordinate.longitude
        }
        
        params["app_id"] = BaatoNetwork.configuration?.appID
        if let userId = BaatoNetwork.configuration?.userID {
            params["user_id"] = userId
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
    
    public func search(query: String, limit: Int = 7, type: String? = nil, radius: Int? = nil, userCoordinate: CLLocationCoordinate2D? = nil, onComplete: @escaping ([BaatoLocationModel]) -> Void,  onError:  @escaping (Error) -> Void) {

        search(query: query, limit: limit, type: type, radius: radius, userCoordinate: userCoordinate).sink { errorCompletetion in
            switch errorCompletetion {
            case .failure(let error):
                onError(error)
            case .finished:
                break
            }
        } receiveValue: { data in
            onComplete(data)
        }.store(in: &bag)

    }

    public func reverseGeocode(coordinate: CLLocationCoordinate2D, limit: Int = 1, radius: Double? = nil) -> AnyPublisher<[BaatoPlaceModel], Error> {
        var params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "",
                                     "lat": coordinate.latitude,
                                     "lon": coordinate.longitude,
                                     "limit": limit]
        if let radius = radius {
            params["radius"] = radius
        }
        params["app_id"] = BaatoNetwork.configuration?.appID
        if let userId = BaatoNetwork.configuration?.userID {
            params["user_id"] = userId
        }
        
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
    
    public func reverseGeocode(coordinate: CLLocationCoordinate2D, limit: Int = 1, radius: Double? = nil, onComplete: @escaping ([BaatoPlaceModel]) -> Void,  onError:  @escaping (Error) -> Void) {
        reverseGeocode(coordinate: coordinate, limit: limit, radius: radius).sink { errorCompletetion in
            switch errorCompletetion {
            case .failure(let error):
                onError(error)
            case .finished:
                break
            }
        } receiveValue: { data in
            onComplete(data)
        }.store(in: &bag)
    }
    
    public func placeDetails(placeId: Int, limit: Int = 1) -> AnyPublisher<[BaatoPlaceModel], Error> {
        var params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "",
                                     "placeId": placeId,
                                     "limit": limit]
        params["app_id"] = BaatoNetwork.configuration?.appID
        if let userId = BaatoNetwork.configuration?.userID {
            params["user_id"] = userId
        }
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
    
    public func placeDetailsForOsmID(osmId: Int, limit: Int = 1) -> AnyPublisher<[BaatoPlaceModel], Error> {
        var params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "",
                                     "osmId": osmId,
                                     "limit": limit]
        params["app_id"] = BaatoNetwork.configuration?.appID
        if let userId = BaatoNetwork.configuration?.userID {
            params["user_id"] = userId
        }
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
    
    public func placeDetailsForOsmID(osmId: Int, limit: Int = 1, onComplete: @escaping ([BaatoPlaceModel]) -> Void,  onError:  @escaping (Error) -> Void) {
        placeDetailsForOsmID(osmId: osmId, limit: limit).sink { errorCompletetion in
            switch errorCompletetion {
            case .failure(let error):
                onError(error)
            case .finished:
                break
            }
        } receiveValue: { data in
            onComplete(data)
        }.store(in: &bag)
    }
    
    public func placeDetails(placeId: Int, limit: Int = 1, onComplete: @escaping ([BaatoPlaceModel]) -> Void,  onError:  @escaping (Error) -> Void) {
        placeDetails(placeId: placeId, limit: limit).sink { errorCompletetion in
            switch errorCompletetion {
            case .failure(let error):
                onError(error)
            case .finished:
                break
            }
        } receiveValue: { data in
            onComplete(data)
        }.store(in: &bag)
    }
    
    public func nearBy(coordinate: CLLocationCoordinate2D, limit: Int = 20, type: String? = nil, radius: Int = 10, isSortByDistance: Bool? = nil, isOpen: Bool? = nil) -> AnyPublisher<[BaatoPlaceModel], Error> {
        var params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "", "lat": coordinate.latitude, "lon":coordinate.longitude, "limit": limit, "radius": radius]
        
        if let type = type {
            params["type"] = type
        }
        
        if let isSortByDistance = isSortByDistance, isSortByDistance == true {
            params["sortBy"] = "distance"
        }
        
        if let isOpen = isOpen {
            params["isOpen"] = isOpen
        }
        
        params["app_id"] = BaatoNetwork.configuration?.appID
        if let userId = BaatoNetwork.configuration?.userID {
            params["user_id"] = userId
        }
 
        return Future<[BaatoPlaceModel], Error> { promise in
            self.cancellable = SwiftNetworking.dataRequest(router: BaatoLocationAPI.nearBy(params)).parse().sink { completion in
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
    
    public func nearBy(coordinate: CLLocationCoordinate2D, limit: Int = 20, type: String? = nil, radius: Int = 10, isSortByDistance: Bool? = nil, isOpen: Bool? = nil, onComplete: @escaping ([BaatoPlaceModel]) -> Void,  onError:  @escaping (Error) -> Void) {
        nearBy(coordinate: coordinate, limit: limit, type: type, radius: radius, isSortByDistance: isSortByDistance, isOpen: isOpen).sink { errorCompletetion in
            switch errorCompletetion {
            case .failure(let error):
                onError(error)
            case .finished:
                break
            }
        } receiveValue: { data in
            onComplete(data)
        }.store(in: &bag)

    }
}
