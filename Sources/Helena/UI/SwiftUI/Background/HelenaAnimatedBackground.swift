//
//  HelenaAnimatedBackground.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


@available(iOS 14.0, *)
public struct HelenaAnimatedBackground<Content: View>: View {
    
    // Values
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    var colors: [Color]
    
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    // Content
    var content: Content
    
    // Init
    public init(colors: [Color]? = nil, content: () -> Content) {
        let bundle = HelenaCentralConfig.assetBundle
        self.content = content()
        self.colors = colors ??
            [Color("DarkBlue-purple", bundle: bundle),
             Color("DarkBlue-indigoBlue", bundle: bundle),
             Color("DarkBlue-deepPurple", bundle: bundle),
             Color("DarkBlue-blue", bundle: bundle),
             Color("DarkBlue-deepPurple", bundle: bundle),
             Color("DarkBlue-indigoBlue", bundle: bundle),
             Color("DarkBlue-purple", bundle: bundle)]
    }
    
    public var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
                .ignoresSafeArea()
                .animation(
                    Animation
                        .easeInOut(duration: 6)
                        .repeatForever()
                )
                .onReceive(timer, perform: { _ in
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                    self.start = UnitPoint(x: -4, y: 20)
                    self.start = UnitPoint(x: 4, y: 0)
                })
                .scaleEffect(1.5)
            
            content
        }
        
        
    }
    
}
