//
//  HelenaSearchField.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import Foundation
import SwiftUI


public struct HelenaSearchField: View {
    
    // Data
    @Binding var searchText: String
    @Binding var showCancelButton: Bool
    
    // Values
    var cancelButtonText: String
    
    /// A texfield with a magnifying glass that indicates serach-functionality.
    public init(searchText: Binding<String>, showCancelButton: Binding<Bool>, cancelButtonText: String? = nil) {
        self._searchText = searchText
        self._showCancelButton = showCancelButton
        self.cancelButtonText = cancelButtonText ?? "Cancel"
    }
    
    // Body
    public var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation(.default) {
                        self.showCancelButton = true
                    }
                }, onCommit: {
                    // print("onCommit")
                }).foregroundColor(.helenaTextAccent)
                
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(HelenaLayout.cornerRadius)
            
            if self.showCancelButton {
                Button(action: {
                    self.endEditing(force: true)
                    self.searchText = ""
                    withAnimation(.default) {
                        self.showCancelButton = false
                    }
                }) {
                    Text(cancelButtonText)
                        .foregroundColor(.helenaTextAccent)
                }
            }
        }.padding(0.5)
    }
    
    // TODO: Prometheus
    private func endEditing(force: Bool) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
}
