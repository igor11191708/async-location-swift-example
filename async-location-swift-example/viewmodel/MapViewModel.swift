//
//  MapViewModel.swift
//  async-location-swift-example
//
//  Created by Igor on 09.02.2023.
//

import SwiftUI
import MapKit
import Combine

/// ViewModel for managing location updates and converting them into a user-friendly format for a map.
final class MapViewModel: ObservableObject {
    
    /// The region to be displayed on the map.
    @Published private(set) var location = MKCoordinateRegion()
    
    /// The human-readable address corresponding to the current location.
    @MainActor @Published private(set) var address: String = ""
    
    /// A publisher to detect and process location updates.
    private let detector: PassthroughSubject<[CLLocation], Never> = .init()
    
    /// A cancellable task for performing asynchronous address encoding.
    private var task: Task<(), Never>?
    
    // MARK: - Lifecycle
    
    /// Cancels the task when the ViewModel is deallocated.
    deinit {
        task?.cancel()
        print("deinit MapViewModel")
    }
    
    /// Initializes the ViewModel and sets up the detector to update the `location` property.
    init() {
        detector
            .map(currentLocation) // Converts location data into an `MKCoordinateRegion`.
            .assign(to: &$location) // Updates the `location` property with the new region.
    }
    
    // MARK: - API
    
    /// Updates the current location and attempts to encode its address.
    ///
    /// - Parameter locations: An array of `CLLocation` objects representing the current position(s).
    public func setCurrentLocation(_ locations: [CLLocation]) {
        detector.send(locations) // Sends the location data to the detector.
        guard let location = locations.last else { return } // Use the most recent location.
        encodeAddress(for: location) // Start address encoding.
    }
    
    /// Sets the address string for the current location on the main thread.
    ///
    /// - Parameter text: The address string to be displayed.
    @MainActor
    func setAddress(text: String) {
        address = text
    }
    
    // MARK: - Private
    
    /// Encodes a `CLLocation` into a human-readable address asynchronously.
    ///
    /// - Parameter location: The `CLLocation` to be converted.
    private func encodeAddress(for location: CLLocation) {
        task?.cancel() // Cancel any ongoing task.
        task = Task {
            do {
                let address = try await AddressDecoder.decode(for: location) // Decode the address.
                await setAddress(text: address) // Update the address on the main thread.
            } catch {
                print(error) // Log any errors that occur.
            }
        }
    }
}

// MARK: - Helpers -

/// Converts a `CLLocation` into a `CLLocationCoordinate2D`.
///
/// - Parameter location: The `CLLocation` to convert.
/// - Returns: The corresponding `CLLocationCoordinate2D`.
fileprivate func coordinate(from location: CLLocation) -> CLLocationCoordinate2D {
    let coord = location.coordinate
    return .init(latitude: coord.latitude, longitude: coord.longitude)
}

/// Generates an `MKCoordinateRegion` from an array of `CLLocation` objects.
///
/// - Parameter locations: An array of `CLLocation` objects.
/// - Returns: An `MKCoordinateRegion` centered around the last location with a default span.
fileprivate func currentLocation(_ locations: [CLLocation]) -> MKCoordinateRegion {
    guard let location = locations.last else { return .init() }
    let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5) // Default zoom level.
    let center = coordinate(from: location) // Center the region around the last location.
    return .init(center: center, span: span)
}
