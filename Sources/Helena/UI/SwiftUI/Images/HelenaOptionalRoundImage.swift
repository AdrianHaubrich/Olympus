//
//  HelenaRoundImage.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// A circular image.
///
/// Mainly used for profile images.
public struct HelenaOptionalRoundImage: View {
    
    // Values
    var image: Image?
    var diameter: CGFloat
    
    // Init
    public init(image: Image? = nil, diameter: CGFloat) {
        self.image = image
        self.diameter = diameter
    }
    
    // Body
    public var body: some View {
        self.image?
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: self.diameter, height: self.diameter)
    }
    
}


/// A circular image.
///
/// Mainly used for profile images.
public struct HelenaRoundImage: View {
    
    // Values
    var image: Image
    var diameter: CGFloat
    
    // Init
    public init(image: Image, diameter: CGFloat) {
        self.image = image
        self.diameter = diameter
    }
    
    // Body
    public var body: some View {
        HelenaOptionalRoundImage(image: image, diameter: diameter)
    }
    
}
