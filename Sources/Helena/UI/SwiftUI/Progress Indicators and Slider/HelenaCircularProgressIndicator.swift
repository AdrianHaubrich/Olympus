//
//  HelenaCircularProgressIndicator.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaCircularProgressIndicator: View {
    
    // Values
    @Binding var progress: CGFloat
    
    // Size
    // var size = UIScreen.main.bounds.width - 100 // TODO: GeometryReader...
    var lineWidth: CGFloat = 20
    
    
    /// This Element is currently in development.
    /// It is strongly encouraged to not use it!
    public init(progress: Binding<CGFloat>) {
        self._progress = progress
    }
    
    // Body
    public var body: some View {
        
        VStack {
            ZStack(alignment: .center) {
                
                // Circle
                Circle()
                    .stroke(Color.helenaBackgroundSmallAccent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                //.frame(width: size, height: size)
                
                // Progress
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.helenaTextAccent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    //.frame(width: size, height: size)
                    .rotationEffect(.init(degrees: -90))
                
                // Start-Dot
                //                Circle()
                //                    .fill(Color(.lightGray))
                //                    .frame(width: lineWidth, height: lineWidth)
                //                    //.offset(x: size / 2)
                //                    .rotationEffect(.init(degrees: -90))
                
                Text(String(format: "%.0f", progress * 100) + "%")
                
            }
        }
        
    }
    
}
