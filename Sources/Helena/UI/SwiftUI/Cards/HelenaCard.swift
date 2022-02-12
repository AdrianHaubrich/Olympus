//
//  HelenaCard.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaCard<Content: View>: View {
    
    // Background Color
    var backgroundColors: [Color]
    
    // Shadow
    var hasShadow: Bool
    
    // Content
    var content: Content
    
    /// A custom card with a flexible size that fits it's content.
    ///
    /// You can (optional) pass multiple colors to create a gradient card. Please make sure that the Color-Array can be used to create a LinearGradient. If the creation fails, the App will crash.
    public init(backgroundColors: [Color]? = nil, hasShadow: Bool? = nil, content: () -> Content) {
        self.content = content()
        self.backgroundColors = backgroundColors ?? [Color.helenaBackground]
        self.hasShadow = hasShadow ?? true
    }
    
    // Body
    public var body: some View {
        
        VStack {
            if self.backgroundColors.count > 1 {
                self.content
                    .background(
                        LinearGradient(gradient: Gradient(colors: self.backgroundColors), startPoint: .leading, endPoint: .trailing)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(HelenaLayout.cornerRadius)
                            .shadow(color: Color.helenaSoftShadow, radius: hasShadow ? HelenaLayout.shadowRadius : 0)
                    )
                    .frame(maxWidth: .infinity)
            } else {
                self.content
                    .background(
                        Rectangle()
                            .fill(self.backgroundColors.first ?? Color.helenaBackground)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(HelenaLayout.cornerRadius)
                            .shadow(color: Color.helenaSoftShadow, radius: hasShadow ? HelenaLayout.shadowRadius : 0)
                    )
                    .frame(maxWidth: .infinity)
            }
        }
        
    }
    
}
