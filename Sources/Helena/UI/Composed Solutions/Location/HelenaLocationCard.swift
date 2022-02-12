//
//  HelenaLocationCard.swift
//  UIDemo
//
//  Created by Adrian Haubrich on 26.11.21.
//

import SwiftUI
import MapKit
import Prometheus

public struct HelenaLocationCard: View {
    
    @StateObject var locationManager = LocationManager()
    @State var selectedLocation: Location?
    let isEditing: Bool
    let onChange: (_ location: Location) -> ()
    
    // UI
    @State var showDetail = false
    var height: CGFloat = 250
    
    // MARK: Init
    public init(selectedLocation: Location? = nil, isEditing: Bool? = nil, onChange: @escaping (Location) -> ()) {
        self.isEditing = isEditing ?? true
        self.onChange = onChange
        self.selectedLocation = selectedLocation
    }
    
    // MARK: Body
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(Color.helenaBackground)
                    .cornerRadius(HelenaLayout.cornerRadius)
                    .shadow(color: Color.helenaSoftShadow, radius: HelenaLayout.shadowRadius)
                
                if let location = self.selectedLocation ?? self.locationManager.lastLocation,
                   let coordinate = self.selectedLocation?.coordinate ?? self.locationManager.lastLocation?.coordinate {
                    
                    // Map
                    HelenaMapView(centerCoordinate: coordinate, annotations: [HelenaLocationCard.createAnnotation(at: coordinate)], onAnnotationSelection: { _ in })
                        .cornerRadius(HelenaLayout.cornerRadius)
                        .onAppear {
                            // Set selected location to current location
                            if self.selectedLocation == nil {
                                self.selectedLocation = location
                                onChange(location)
                            }
                        }
                    
                    // Overlay
                    ZStack(alignment: .topLeading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(location.name ?? "")
                                    .helenaFont(type: .cardMediumText)
                                    .foregroundColor(Color.helenaText)
                                Text(location.address ?? "")
                                    .helenaFont(type: .cardText)
                                    .foregroundColor(Color.helenaTextSmallAccent)
                            }
                            Spacer()
                            Image(systemName: "chevron.compact.right")
                                .helenaFont(type: .cardTitle)
                                .foregroundColor(Color.helenaTextAccent)
                        }
                        .padding()
                        .background(
                            Rectangle()
                                .fill(Color.helenaBackground.opacity(0.85))
                                .cornerRadius(HelenaLayout.cornerRadius, corners: [.bottomLeft, .bottomRight]))
                    }.onTapGesture {
                        self.showDetail.toggle()
                    }
                    // Detail
                    .sheet(isPresented: $showDetail) {
                        HelenaLocationCardDetailView(selectedLocation: location, isShowingDetail: $showDetail, isEditing: self.isEditing) { location in
                            self.selectedLocation = location
                            onChange(location)
                        }
                    }
                } else {
                    // Loading
                    GeometryReader { m in
                        HelenaLinearProgressIndicator(text: "Loading...", width: m.size.width - 12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: self.height)
        }
    }
    
}

extension HelenaLocationCard {
    
    static func createAnnotation(at coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
    
}
