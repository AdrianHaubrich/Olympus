//
//  HelenaBackgroundImage.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 07.02.21.
//

import SwiftUI


public struct HelenaBackgroundImageModifier: ViewModifier {
    
    public var named: String
    
    public init(_ named: String) {
        self.named = named
    }
    
    public func body(content: Content) -> some View {
        return ZStack {
            HelenaFullScreenImage(named)
            content
        }
    }
    
    
}

extension View {
    public func helenaBackgroundImage(named: String) -> some View {
        return self.modifier(HelenaBackgroundImageModifier(named))
    }
}
