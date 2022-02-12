//
//  HelenaFullScreenImage.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// An image that fills the available space and ignores the safe area.
public struct HelenaFullScreenImage: View {
    
    // Image
    var named: String
    
    // Init
    public init(_ named: String) {
        self.named = named
    }
    
    public var body: some View {
        GeometryReader { geo in
            Image("\(self.named)")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
