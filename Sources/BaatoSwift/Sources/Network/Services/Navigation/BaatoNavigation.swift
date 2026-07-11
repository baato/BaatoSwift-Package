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
    var bag = Set<AnyCancellable>()
    
    public func directions(points: [CLLocationCoordinate2D], mode: BaatoNavigationMode, isInstructionEnable: Bool = false) -> AnyPublisher<[BaatoNavigationModel], Error> {
        let arrayPoints = points.map({"\($0.latitude),\($0.longitude)"})
        let params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "", "points": arrayPoints, "mode": mode, "instructions": isInstructionEnable]
 
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
    
    public func directions(points: [CLLocationCoordinate2D], mode: BaatoNavigationMode, isInstructionEnable: Bool = false, onComplete: @escaping ([BaatoNavigationModel]) -> Void,  onError:  @escaping (Error) -> Void) {
        directions(points: points, mode: mode, isInstructionEnable: isInstructionEnable).sink { errorCompletetion in
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
    
    public func alterNativeDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isInstructionEnable: Bool = false) -> AnyPublisher<[BaatoNavigationModel], Error> {
        let arrayPoints = [startPoint, endPoint].map({"\($0.latitude),\($0.longitude)"})
        let params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "", "points": arrayPoints, "mode": mode, "instructions": isInstructionEnable, "alternatives": true]
 
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
    
    public func alterNativeDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isInstructionEnable: Bool = false, onComplete: @escaping ([BaatoNavigationModel]) -> Void,  onError:  @escaping (Error) -> Void) {
        alterNativeDirections(startPoint: startPoint, endPoint: endPoint, mode: mode, isInstructionEnable: isInstructionEnable).sink { errorCompletetion in
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
    
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isAlternativeEnable: Bool = false) -> AnyPublisher<Data, Error> {
        return mapBoxDirections(startPoint: startPoint, endPoint: endPoint, mode: mode, isAlternativeEnable: isAlternativeEnable, locale: nil)
    }

    /// Fetches Mapbox-compatible directions with optional locale for voice instructions
    /// - Parameters:
    ///   - startPoint: Starting coordinate
    ///   - endPoint: Ending coordinate
    ///   - mode: Navigation mode (car, bike, foot, etc.)
    ///   - isAlternativeEnable: Whether to include alternative routes
    ///   - locale: Optional locale for voice instructions (e.g., "ne-NP", "en-US"). If nil, uses API default.
    /// - Returns: Publisher with raw Data response
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isAlternativeEnable: Bool = false, locale: String?) -> AnyPublisher<Data, Error> {
        return mapBoxDirections(startPoint: startPoint, endPoint: endPoint, mode: mode, isAlternativeEnable: isAlternativeEnable, locale: locale, heading: nil)
    }

    /// Fetches Mapbox-compatible directions with optional locale and heading for better rerouting
    /// - Parameters:
    ///   - startPoint: Starting coordinate
    ///   - endPoint: Ending coordinate
    ///   - mode: Navigation mode (car, bike, foot, etc.)
    ///   - isAlternativeEnable: Whether to include alternative routes
    ///   - locale: Optional locale for voice instructions (e.g., "ne-NP", "en-US"). If nil, uses API default.
    ///   - heading: Optional heading in degrees (0-360, north-based clockwise) for better route calculation during rerouting
    /// - Returns: Publisher with raw Data response
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isAlternativeEnable: Bool = false, locale: String?, heading: Double?) -> AnyPublisher<Data, Error> {
        let arrayPoints = [startPoint, endPoint].map({"\($0.latitude),\($0.longitude)"})
        var params: [String: Any] = ["key": BaatoNetwork.configuration?.key ?? "", "points": arrayPoints, "mode": mode, "instructions": true, "forMapbox": true, "alternatives": isAlternativeEnable]

        // Add locale parameter if provided
        if let locale = locale {
            params["locale"] = locale
        }

        // Add heading parameter if provided (for rerouting)
        if let heading = heading, heading >= 0 && heading < 360 {
            params["heading"] = heading
        }

        return Future<Data, Error> { promise in
            self.cancellable = SwiftNetworking.dataRequest(router: BaatoNavigationAPI.directions(params)).parse().sink { completion in
                   switch completion {
                   case .finished:
                      break
                   case .failure(let error):
                       promise(.failure(error))
                   }
               } receiveValue: { response in
                    promise(.success(response))
               }
        }.eraseToAnyPublisher()
    }

    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isAlternativeEnable: Bool = false, onComplete: @escaping (Data) -> Void,  onError:  @escaping (Error) -> Void) {
        mapBoxDirections(startPoint: startPoint, endPoint: endPoint, mode: mode, isAlternativeEnable: isAlternativeEnable, locale: nil, onComplete: onComplete, onError: onError)
    }

    /// Fetches Mapbox-compatible directions with optional locale for voice instructions (callback version)
    /// - Parameters:
    ///   - startPoint: Starting coordinate
    ///   - endPoint: Ending coordinate
    ///   - mode: Navigation mode (car, bike, foot, etc.)
    ///   - isAlternativeEnable: Whether to include alternative routes
    ///   - locale: Optional locale for voice instructions (e.g., "ne-NP", "en-US"). If nil, uses API default.
    ///   - onComplete: Success callback with raw Data response
    ///   - onError: Error callback
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isAlternativeEnable: Bool = false, locale: String?, onComplete: @escaping (Data) -> Void,  onError:  @escaping (Error) -> Void) {
        mapBoxDirections(startPoint: startPoint, endPoint: endPoint, mode: mode, isAlternativeEnable: isAlternativeEnable, locale: locale, heading: nil, onComplete: onComplete, onError: onError)
    }

    /// Fetches Mapbox-compatible directions with optional locale and heading (callback version)
    /// - Parameters:
    ///   - startPoint: Starting coordinate
    ///   - endPoint: Ending coordinate
    ///   - mode: Navigation mode (car, bike, foot, etc.)
    ///   - isAlternativeEnable: Whether to include alternative routes
    ///   - locale: Optional locale for voice instructions (e.g., "ne-NP", "en-US"). If nil, uses API default.
    ///   - heading: Optional heading in degrees (0-360, north-based clockwise) for better route calculation during rerouting
    ///   - onComplete: Success callback with raw Data response
    ///   - onError: Error callback
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, isAlternativeEnable: Bool = false, locale: String?, heading: Double?, onComplete: @escaping (Data) -> Void,  onError:  @escaping (Error) -> Void) {
        mapBoxDirections(startPoint: startPoint, endPoint: endPoint, mode: mode, isAlternativeEnable: isAlternativeEnable, locale: locale, heading: heading).sink { errorCompletetion in
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

