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
    
    private let detector : PassthroughSubject<[CLLocation], Never> = .init()
    
    // MARK: - Life circle
    
    deinit{
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
    }
}

fileprivate func currentLocation(_ locations : [CLLocation] ) -> MKCoordinateRegion{
    
    guard let location =  locations.last else{ return MKCoordinateRegion() }
    
    let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    let coordinate = location.coordinate
    let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    
    return MKCoordinateRegion(center: center, span: span )
}
