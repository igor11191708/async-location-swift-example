//
//  MapView.swift
//  async-location-swift-example
//
//  Created by Igor on 09.02.2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable  {

    @EnvironmentObject private var mapViewModel: MapViewModel
    
    let mapType : MKMapType
    
    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.mapType = mapType
        mapView.setRegion(mapViewModel.location, animated: false)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        uiView.setRegion(mapViewModel.location, animated: true)
    }

}
