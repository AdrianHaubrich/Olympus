//
//  HelenaCentralConfig.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import Foundation
import SwiftUI


public class HelenaCentralConfig {
     
    // Singleton
    public static let shared = HelenaCentralConfig()
    
    // Assets
    public static let assetBundle = Bundle.module // Bundle(for: HelenaCentralConfig.self)
    
    // Layout
    public var colorStyle: ColorStyle = .orange {
        didSet {
            setColorStyle(style: colorStyle)
        }
    }
    
    // Error
    public var defaultErrorMessage = "Oh no, an error occured."
    
    
    // Init
    public init() {}
    
}


// MARK: Color Style
extension HelenaCentralConfig {
    
    private func setColorStyle(with prefix: String) {
        
        Color.prefix = prefix
        
        Color.helenaBackground = Color("General-background", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaBackgroundAccent = Color("\(prefix)-accentBackground", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaGradientAccent = Color("\(prefix)-gradientAccent", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaBackgroundDark = Color("\(prefix)-darkBackground", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaBackgroundSmallAccent = Color("General-smallAccentBackgroundColor", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaBackgroundSmallTransparentAccent = Color("General-smallTransparentAccentBackgroundColor", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaBackgroundOwnMessage = Color("\(prefix)-ownMessageBackground", bundle: HelenaCentralConfig.assetBundle)
        
        // Text
        Color.helenaText = Color("General-textColor", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaTextAccent = Color("\(prefix)-accent", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaTextAccentLight = Color("\(prefix)-accentLight", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaTextLight = Color("General-lightTextColor", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaTextSmallAccent = Color("General-smallAccentTextColor", bundle: HelenaCentralConfig.assetBundle)
        Color.helenaTextSmallAccentStrong = Color("General-smallAccentStrongTextColor", bundle: HelenaCentralConfig.assetBundle)
        
        Color.helenaPlaceholder = Color(UIColor.lightGray)
        Color.helenaError = Color.red
        
        Color.helenaTabIcon = Color("\(prefix)-tapIconColor", bundle: HelenaCentralConfig.assetBundle)
        
        // Shadow
        Color.helenaSoftShadow = Color(.sRGBLinear, white: 0, opacity: 0.13)
        
        // Border
        Color.helenaTextViewBorder = Color(UIColor.gray.withAlphaComponent(0.5))
    }
    
    func setColorStyle(style: ColorStyle) {
        switch style {
            case .orange:
                setColorStyle(with: "Orange")
            
            case .darkBlue:
                setColorStyle(with: "DarkBlue")
        }
    }
    
}


public enum ColorStyle {
    case orange, darkBlue
}
