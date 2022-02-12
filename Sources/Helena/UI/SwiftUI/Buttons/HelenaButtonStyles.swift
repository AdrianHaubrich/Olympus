//
//  HelenaButtonStyles.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// Button style to emphasize an action.
public struct HelenaPrimaryButtonStyle: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(Color.helenaTextAccent)
            .cornerRadius(10.0)
    }
}

/// Default button style.
public struct HelenaSecondaryButtonStyle: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.helenaText)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(Color.helenaBackgroundSmallAccent)
            .cornerRadius(10.0)
    }
    
}

/// Default button style.
public struct HelenaDangerButtonStyle: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color(.systemRed))
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(Color.helenaBackgroundSmallAccent)
            .cornerRadius(10.0)
    }
    
}
