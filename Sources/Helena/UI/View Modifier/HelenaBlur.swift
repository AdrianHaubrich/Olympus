//
//  HelenaBlur.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 25.01.21.
//

import SwiftUI

/// This is a modified blur with the goal to increase the readibility
/// of white text on top of the blured element.
public struct HelenaBlur: ViewModifier {
    
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .blur(radius: HelenaLayout.blurRadius)
            .contrast(1.25)
            .brightness(0.08)
            .saturation(1.5)
    }
}

extension View {
    public func helenaBlur() -> some View {
        modifier(HelenaBlur())
    }
}
