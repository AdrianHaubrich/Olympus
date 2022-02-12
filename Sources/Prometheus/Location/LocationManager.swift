//
//  LocationManager.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import Foundation
import CoreLocation
import MapKit
import Combine

public class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published public var locationStatus: CLAuthorizationStatus?
    @Published public var lastLocation: Location?
    
    public var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
            case .notDetermined: return "notDetermined"
            case .authorizedWhenInUse: return "authorizedWhenInUse"
            case .authorizedAlways: return "authorizedAlways"
            case .restricted: return "restricted"
            case .denied: return "denied"
            default: return "unknown"
        }
    }
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}


// MARK: - Update Current Location
extension LocationManager {
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    public func updateLocation() {
        locationManager.requestLocation()
    }
    
}


// MARK: - CLPlacemark
extension LocationManager {
    
    /// Get placemark at a specific coordinate
    public static func getPlacemark(at coordinate: CLLocationCoordinate2D) async throws -> CLPlacemark {
        
        // Create CLLocation
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Geocode
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks?.first else {
                throw LocationError.unableToReverseGeocodePlacemark
            }
            return placemark
            
        } catch {
            throw error
        }
    }
    
}


// MARK: Location
extension LocationManager {
    
    public static func getLocation(by placemark: CLPlacemark) -> Location {
        return LocationManagerLocation(placemark: placemark)
    }
    
}


// MARK: - Search
extension LocationManager {
    
    public static func searchMKMapItems(with: String, inPreferedRegion: MKCoordinateRegion) async throws -> [MKMapItem] {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = with
        request.region = inPreferedRegion
        
        let search = MKLocalSearch(request: request)
        
        do {
            let response = try await search.start()
            return response.mapItems
        } catch {
            throw error
        }
    }
    
}


// MARK: Parse Adress
extension LocationManager {
    
    // Parse Adress
    /// Parses a CLPlacemark in a user friendly textual representation.
    ///
    /// - Parameter matchingItem: The placemark that should be parsed.
    public static func parseCLAddress(matchingItem: CLPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (matchingItem.subThoroughfare != nil && matchingItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (matchingItem.subThoroughfare != nil || matchingItem.thoroughfare != nil) && (matchingItem.subAdministrativeArea != nil || matchingItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (matchingItem.subAdministrativeArea != nil && matchingItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            matchingItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            matchingItem.thoroughfare ?? "",
            comma,
            // city
            matchingItem.locality ?? "",
            secondSpace,
            // state
            matchingItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    // Parse Adress
    /// Convinient method to parse a MKPlacemark as an CLPlacemark  in a user friendly representation.
    ///
    /// - Parameter matchingItem: The placemark that should be parsed.
    public static func parseMKAddress(matchingItem: MKPlacemark) -> String {
        parseCLAddress(matchingItem: matchingItem)
    }
    
    
    public static func parseCity(of placemark: CLPlacemark) -> String {
        return placemark.locality ?? placemark.thoroughfare ?? "(\(placemark.location?.coordinate.latitude ?? 0)|\(placemark.location?.coordinate.longitude ?? 0))"
    }
    
}


// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get last location
        guard let location = locations.last else { return }
        
        Task.detached {
            
            // Get placemark at last location
            let placemark = try? await LocationManager.getPlacemark(at: location.coordinate)
            
            guard let placemark = placemark else {
                return
            }
            
            // Convert to Location
            DispatchQueue.main.async {
                self.lastLocation = LocationManager.getLocation(by: placemark)
            }
        }
        
    }
    
}
