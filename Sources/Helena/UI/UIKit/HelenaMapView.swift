//
//  HelenaMapView.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI
import MapKit


/// Implements UIMapView in SwiftUI.
public struct HelenaMapView: UIViewRepresentable {
    
    var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    
    var isUserInteractionEnabled : Bool = false
    let showUserLocation: Bool
    let showScale: Bool
    let showCompass: Bool
    let showTraffic: Bool
    let showBuildings: Bool
    
    var onAnnotationSelection: (_ annotationView: MKAnnotationView) -> ()
    
    
    public init(centerCoordinate: CLLocationCoordinate2D,
                annotations: [MKPointAnnotation],
                isUserInteractionEnabled: Bool? = nil,
                showUserLocation: Bool? = nil,
                showScale: Bool? = nil,
                showCompass: Bool? = nil,
                showTraffic: Bool? = nil,
                showBuildings: Bool? = nil,
                onAnnotationSelection: @escaping (_ annotationView: MKAnnotationView) -> ()) {
        self.centerCoordinate = centerCoordinate
        self.annotations = annotations
        
        self.isUserInteractionEnabled = isUserInteractionEnabled ?? false
        self.showUserLocation = showUserLocation ?? false
        self.showScale = showScale ?? false
        self.showCompass = showCompass ?? false
        self.showTraffic = showTraffic ?? false
        self.showBuildings = showBuildings ?? false
        
        self.onAnnotationSelection = onAnnotationSelection
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.isUserInteractionEnabled = isUserInteractionEnabled
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.showsUserLocation = showUserLocation
        mapView.showsScale = showScale
        mapView.showsCompass = showCompass
        mapView.showsTraffic = showTraffic
        mapView.showsBuildings = showBuildings
        return mapView
    }
    
    public func updateUIView(_ view: MKMapView, context: Context) {
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        view.setRegion(coordinateRegion, animated: true)
        
        // TOOD: Only remove and add annotations if they actually changed...
        view.removeAnnotations(view.annotations)
        view.addAnnotations(annotations)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, MKMapViewDelegate {
        var parent: HelenaMapView
        
        public init(_ parent: HelenaMapView) {
            self.parent = parent
        }
        
        public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
            print("didSelectAnnotationTapped")
            parent.onAnnotationSelection(view)
        }
    }
}

// Sample Data
extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}
