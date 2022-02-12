//
//  HelenaLocationCardDetailView.swift
//  UIDemo
//
//  Created by Adrian Haubrich on 26.11.21.
//

import SwiftUI
import MapKit
import Prometheus

struct HelenaLocationCardDetailView: View {
    
    @State var selectedLocation: Location
    @Binding var isShowingDetail: Bool
    var isEditing: Bool = true
    
    let onChange: (_ location: Location) -> ()
    
    // Search
    @State var searchText: String = ""
    @State var searchResults: [MKMapItem] = []
    
    // UI
    @State var showCancelButton: Bool = false
    @State var showSearchResults: Bool = true
    @State var dismissString: String = DismissOptions.done.rawValue
    
    enum DismissOptions: String {
        case done = "Done"
        case select = "Select"
    }
    
    
    // MARK: Body
    var body: some View {
        if let coordinate = self.selectedLocation.coordinate {
            
            ZStack(alignment: .top) {
                
                // Map
                HelenaMapView(centerCoordinate: coordinate, annotations: [HelenaLocationCard.createAnnotation(at: coordinate)], isUserInteractionEnabled: true, onAnnotationSelection: { _ in
                    self.isShowingDetail.toggle()
                })
                    .edgesIgnoringSafeArea(.all)
                
                
                // Search
                HelenaCard {
                    VStack {
                        
                        HStack {
                            Text("Location")
                                .helenaFont(type: .cardTitle)
                                .foregroundColor(Color.helenaTextSmallAccent)
                            
                            Spacer()
                            
                            Button(action: {
                                self.isShowingDetail.toggle()
                            }) {
                                Text(dismissString)
                                    .helenaFont(type: .cardText)
                                    .foregroundColor(Color.helenaTextAccent)
                            }
                        }
                        
                        if isEditing {
                            HelenaSearchField(searchText: $searchText, showCancelButton: $showCancelButton)
                                .onTapGesture {
                                    self.showSearchResults = true
                                }
                                .onChange(of: searchText) { newValue in
                                    search(with: newValue)
                                }
                        } else {
                            Text(selectedLocation.name ?? "")
                                .helenaFont(type: .emphasizedText)
                                .foregroundColor(Color.helenaText)
                            Text(selectedLocation.address ?? "")
                                .helenaFont(type: .cardText)
                                .foregroundColor(Color.helenaTextSmallAccent)
                        }
                        
                        if self.searchResults.count > 0 && showCancelButton && showSearchResults {
                            // Results
                            List {
                                ForEach(self.searchResults, id: \.self) { item in
                                    LocationCell(location: item)
                                        .onTapGesture {
                                            
                                            // Select item as location
                                            self.selectedLocation = LocationManagerLocation(placemark: item.placemark)
                                            self.onChange(self.selectedLocation)
                                            
                                            // Hide Results & Keyboard & Cancel Button
                                            withAnimation(.default) {
                                                // TODO: Hide keyboard
                                                self.showSearchResults = false
                                                self.showCancelButton = false
                                            }
                                            
                                            // Change Text in Search Field
                                            self.searchText = item.name ?? ""
                                            
                                            // Change Dismiss String
                                            self.dismissString = DismissOptions.select.rawValue
                                        }
                                }
                            }
                        }
                        
                    }
                    .padding()
                }
                
            }
            
        }
    }
    
}


// MARK: - Search
extension HelenaLocationCardDetailView {
    
    func search(with searchText: String) {
        Task.detached {
            guard let coordinate = self.selectedLocation.coordinate else {
                return
            }
            let delta: CLLocationDegrees = 1
            let items = try? await LocationManager.searchMKMapItems(with: searchText,
                                                                    inPreferedRegion: MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)))
            
            // Set result
            if let items = items {
                self.searchResults = items
            }
        }
    }
    
}


// MARK: - Views
struct LocationCell: View {
    
    // Data
    @State var location: MKMapItem
    
    // Body
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(location.name ?? "")
                .helenaFont(type: .cardTitle)
                .foregroundColor(Color.helenaText)
            Text(LocationManager.parseMKAddress(matchingItem: location.placemark))
                .helenaFont(type: .cardText)
                .foregroundColor(Color.helenaText)
        }
        
    }
    
}
