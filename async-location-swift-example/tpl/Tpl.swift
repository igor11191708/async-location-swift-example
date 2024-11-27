//
//  Tpl.swift
//  async-location-swift-example
//
//  Created by Igor Shelopaev  on 27.11.24.
//

import SwiftUI
import MapKit

struct ViewTpl{
    
    @ViewBuilder
    static func coordinateTpl(_ center : CLLocationCoordinate2D) -> some View{
            HStack {
        
                Text("Longitude: \(center.longitude, specifier: "%.6f")")
                Spacer()
                Text("Latitude: \(center.latitude, specifier: "%.6f")")
            }.toolbarItemModifier()
            .padding(.horizontal)
    }
    
    @ViewBuilder
    static func addressTpl(_ address: String) -> some View{
            Text(address)
                .toolbarItemModifier()
    }
    
    @ViewBuilder
    static func errorTpl(_ error: Error) -> some View{
            Text(error.localizedDescription)
                .toolbarItemModifier()
                .multilineTextAlignment(.center)
    }
    
}
