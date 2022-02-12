//
//  HelenaVisualEffectsView.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import Foundation
import SwiftUI


public struct VisualEffects: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    public init(style: UIBlurEffect.Style? = nil) {
        self.style = style ?? .systemMaterial
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
    
}
