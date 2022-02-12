//
//  HelenaCornerRadius.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 25.01.21.
//

import SwiftUI


public struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension View {
    
    /// Round specifig Corners
    /// - Usage: .cornerRadius(20, corners: [.topLeft, .bottomRight])
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
}
