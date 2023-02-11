//
//  AddressEncoder.swift
//  async-location-swift-example
//
//  Created by Igor on 11.02.2023.
//

import CoreLocation
import Contacts

enum AddressDecoder {
    
    enum AdressError: Error{
        case noAddressesFound
    }
    
    /// Async function to convert a ``CLLocation`` into a  readable address
    static func decode(for location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let lines = try await geocoder.reverseGeocodeLocation(location)
        
        guard let mark = lines.first,  let address = mark.postalAddress else {
            throw AdressError.noAddressesFound
        }
        
        return CNPostalAddressFormatter.string(from: address, style: .mailingAddress)
        
    }
}
