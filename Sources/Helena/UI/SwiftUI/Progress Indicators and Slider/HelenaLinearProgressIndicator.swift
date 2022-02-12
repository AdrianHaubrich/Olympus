//
//  HelenaLinearProgressIndicator.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaLinearProgressIndicator: View {
    
    // Data
    var text: String
    
    // Values
    @State var width: CGFloat
    @State private var moveRightLeft = false
    
    // Init
    public init(text: String, width: CGFloat) {
        self.text = text
        self._width = State(initialValue: width)
    }
    
    public var body: some View {
        VStack {
            ZStack {
                // Background Capsule
                Capsule()
                    .frame(height: 6, alignment: .center)
                    .foregroundColor(.helenaBackgroundSmallAccent)
                
                // Progress Capsule
                Capsule()
                    .clipShape(Rectangle().offset(x: self.moveRightLeft ? (width * 0.66) : (width * -0.66)))
                    .frame(height: 6, alignment: .leading)
                    .foregroundColor(.helenaTextAccent)
                    .offset(x: self.moveRightLeft ? 0 : 0)
                    .animation(Animation.easeInOut(duration: 0.5).delay(0.2).repeatForever(autoreverses: true))
                    .onAppear {
                        self.moveRightLeft.toggle()
                    }
            }
            .padding()
            
            // Text
            Text(self.text)
        }
        .padding(20)
    }
}
