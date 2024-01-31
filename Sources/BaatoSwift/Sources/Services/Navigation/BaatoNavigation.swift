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
    
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode) -> AnyPublisher<Data, Error> {
        let arrayPoints = [startPoint, endPoint].map({"\($0.latitude),\($0.longitude)"})
        let params: [String: Any] = ["key": BaatoNetwork.configure?.key ?? "", "points": arrayPoints, "mode": mode, "instructions": true, "forMapbox": true]
 
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
    
    public func mapBoxDirections(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, mode: BaatoNavigationMode, onComplete: @escaping (Data) -> Void,  onError:  @escaping (Error) -> Void) {
        mapBoxDirections(startPoint: startPoint, endPoint:endPoint, mode: mode).sink { errorCompletetion in
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

