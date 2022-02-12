//
//  Location.swift
//  
//
//  Created by Adrian Haubrich on 26.11.21.
//

import Foundation
import MapKit

public protocol Location {
    
    var name: String? { get }
    var address: String? { get }
    var coordinate: CLLocationCoordinate2D? { get }
    
    init(placemark: CLPlacemark)
    
}

public struct LocationManagerLocation: Location {
    
    public let name: String?
    public let address: String?
    public let coordinate: CLLocationCoordinate2D?
    
    public init(placemark: CLPlacemark) {
        self.name = placemark.name
        self.address = LocationManager.parseCLAddress(matchingItem: placemark)
        self.coordinate = placemark.location?.coordinate
    }
    
    public init(name: String?, address: String? = nil, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }
    
}
