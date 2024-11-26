//
//  AddressEncoder.swift
//  async-location-swift-example
//
//  Created by Igor on 11.02.2023.
//

import CoreLocation
import Contacts

/// A utility for decoding `CLLocation` objects into human-readable addresses.
enum AddressDecoder {
    
    /// An error type representing possible decoding failures.
    enum AddressError: Error {
        /// Indicates that no address was found for the provided location.
        case noAddressFound
    }
    
    /// Converts a `CLLocation` into a readable address string asynchronously.
    ///
    /// - Parameter location: The `CLLocation` to decode.
    /// - Returns: A `String` containing the formatted address.
    /// - Throws: An `AddressError` if no address could be found.
    static func decode(for location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first, let address = placemark.postalAddress else {
            throw AddressError.noAddressFound
        }
        
        return CNPostalAddressFormatter.string(from: address, style: .mailingAddress)
    }
}
