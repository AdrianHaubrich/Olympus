//
//  HelenaRoundImageCropping.swift
//  UniteSwiftUI
//
//  Created by Nico Weigmann on 10.02.21.
//  Copyright © 2021 Adrian Haubrich. All rights reserved.
//

import SwiftUI

public struct HelenaRoundImageCropping: View {
    
    // Values
    var image: Image
    var rect: CGRect
    var scale: CGFloat
    var offset: CGSize
    
    public init(image: Image, rect: CGRect, scale: CGFloat, offset: CGSize) {
        self.image = image
        self.rect = rect
        self.scale = scale
        self.offset = offset
    }
    
    // Body
    public var body: some View {
        image
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: rect.width, height: rect.height)
            .scaleEffect(scale)
            .offset(offset)
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(0.45))
                    .mask(clipHole(in: rect).fill(style: FillStyle(eoFill: true)))
                    .frame(width: rect.width, height: rect.height)
            )
    }
    
    private func clipHole(in rect: CGRect) -> Path {
        var shape = Rectangle().path(in: rect)
        shape.addPath(Circle().path(in: rect))
        return shape
    }
    
}
