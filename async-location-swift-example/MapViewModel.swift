//
//  MapViewModel.swift
//  async-location-swift-example
//
//  Created by Igor on 09.02.2023.
//

import SwiftUI
import MapKit

final class MapViewModel : ObservableObject{
    
    @Published var location = MKCoordinateRegion()
    
    private let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    
    func setCurrentLocation(_ locations : [CLLocation] ){
        
        guard let location =  locations.last else{ return }
        
        let coordinate = location.coordinate
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        self.location = MKCoordinateRegion(center: center, span: span )
        
    }
}
