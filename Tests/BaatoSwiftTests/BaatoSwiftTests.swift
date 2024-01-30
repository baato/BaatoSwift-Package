import XCTest
@testable import BaatoSwift
import Combine
import CoreLocation

@available(iOS 13.0, *)
final class BaatoSwiftTests: XCTestCase {
    var bag = Set<AnyCancellable>()
    
    func testExample() throws {
        BaatoSwift.configure(configure: Configuration(mode: .live, key: "bpk.TqpOIK5KflKR_zEI0ONEVdCZmwmfMye9i67nAjsGlMgQ"))
        
        try testReverse()
//        try testSearch()
//        try testPlaceDetail()
//        try testDirections()
    }
    
    func testSearch() throws {
       
        var places = [BaatoLocationModel]()
        var errorRes: Error?
        
        let expectation = self.expectation(description: "Search Test")
        
        let res = BaatoSwift.location.search(query: "s", limit: 10, type: "town")
       
        res.sink { error in
           print(error)
            switch error {
            case .failure(let error):
                errorRes = error
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { data in
            places = data
            print(places.count)
            expectation.fulfill()
        }.store(in: &bag)
        
        waitForExpectations(timeout: 20)
        
        XCTAssertNil(errorRes)
        XCTAssertTrue(!places.isEmpty)
    }
    
    func testReverse() throws {
       
        var places = [BaatoPlaceModel]()
        var errorRes: Error?
        
        let expectation = self.expectation(description: "Reverse Test")
        
        let res = BaatoSwift.location.reverseGeocode(coordinate: CLLocationCoordinate2D(latitude: 27.70446921370009, longitude: 85.32051086425783))
       
        res.sink { error in
           print(error)
            switch error {
            case .failure(let error):
                print(error)
                errorRes = error
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { data in
            places = data
            print(places.count)
            expectation.fulfill()
        }.store(in: &bag)
        
        waitForExpectations(timeout: 20)
        
        XCTAssertNil(errorRes)
        XCTAssertTrue(!places.isEmpty)
    }
    
    func testPlaceDetail() throws {
       
        var places = [BaatoPlaceModel]()
        var errorRes: Error?
        
        let expectation = self.expectation(description: "Place detail")
        
        let res = BaatoSwift.location.placeDetails(placeId: 102235)
       
        res.sink { error in
           print(error)
            switch error {
            case .failure(let error):
                print(error)
                errorRes = error
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { data in
            places = data
            print(places.count)
            expectation.fulfill()
        }.store(in: &bag)
        
        waitForExpectations(timeout: 20)
        
        XCTAssertNil(errorRes)
        XCTAssertTrue(!places.isEmpty)
    }
    
    func testDirections() throws {
        let points = [
            CLLocationCoordinate2D(latitude: 27.724316366064567, longitude: 85.33965110778809),
            CLLocationCoordinate2D(latitude: 27.72752634726644, longitude: 85.34164667129517),
            CLLocationCoordinate2D(latitude: 27.729311739688477, longitude: 85.34417867660522),
            CLLocationCoordinate2D(latitude: 27.731761858279167, longitude: 85.3443717956543),
            CLLocationCoordinate2D(latitude: 27.7352, longitude: 85.3468),
            CLLocationCoordinate2D(latitude: 27.7418, longitude: 85.3479),
        ]
        
        var places = [BaatoNavigationModel]()
        var errorRes: Error?
        
        let expectation = self.expectation(description: "Direction")
        
        let res = BaatoSwift.navigation.directions(points: points, mode: BaatoNavigationMode.car, isInstructionEnable: true)
       
        res.sink { error in
           print(error)
            switch error {
            case .failure(let error):
                print(error)
                errorRes = error
            case .finished:
                break
            }
            expectation.fulfill()
        } receiveValue: { data in
            places = data
            print(places.count)
            expectation.fulfill()
        }.store(in: &bag)
        
        waitForExpectations(timeout: 20)
        
        XCTAssertNil(errorRes)
        XCTAssertTrue(!places.isEmpty)
    }
}
