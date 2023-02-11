//
//  MapViewModel.swift
//  async-location-swift-example
//
//  Created by Igor on 09.02.2023.
//

import SwiftUI
import MapKit
import Combine

final class MapViewModel : ObservableObject{
    
    @Published private(set) var location = MKCoordinateRegion()
    
    @MainActor @Published private(set) var address : String = ""
    
    private let detector : PassthroughSubject<[CLLocation], Never> = .init()
    
    private var task : Task<(), Never>?
    
    // MARK: - Life circle
    
    deinit{
        task?.cancel()
        print("deinit MapViewModel")
    }
    
    init(){
        detector
            .map(currentLocation)
            .assign(to: &$location)
    }
    
    // MARK: - API
    
    public func setCurrentLocation(_ locations : [CLLocation]){
        detector.send(locations)
        
        guard let location = locations.last else{ return }
        
        encodeAddress(for: location)
    }
    
    @MainActor
    func setAddress(text : String){
     address = text
    }
    
    // MARK: - Private
    
    private func encodeAddress(for location : CLLocation){
        
        task?.cancel()
        
        task = Task{
            do{
                let address = try await AddressDecoder.decode(for: location)
                await setAddress(text: address)
            }catch{
                print(error)
            }
        }
    }
}

// MARK: - Helpers -

fileprivate func coordinate(from location: CLLocation) -> CLLocationCoordinate2D{
    
    let coord = location.coordinate
    
    return .init(latitude: coord.latitude, longitude: coord.longitude)
}

fileprivate func currentLocation(_ locations : [CLLocation] ) -> MKCoordinateRegion{
    
    guard let location =  locations.last else{ return .init() }
    
    let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    let center = coordinate(from: location)
    
    return .init(center: center, span: span )
}
