//
//  HelenaColors.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 25.01.21.
//

import Foundation
import SwiftUI

class HelenaFrameworkAnchor {
    
}

extension Color {
    
    public static var bundle = HelenaCentralConfig.assetBundle
    public static var prefix: String = "DarkBlue"
    
    public static var helenaBackground = Color("General-background", bundle: bundle)
    public static var helenaBackgroundAccent = Color("\(prefix)-accentBackground", bundle: bundle)
    public static var helenaGradientAccent = Color("\(prefix)-gradientAccent", bundle: bundle)
    public static var helenaBackgroundDark = Color("\(prefix)-darkBackground", bundle: bundle)
    public static var helenaBackgroundSmallAccent = Color("General-smallAccentBackgroundColor", bundle: bundle)
    public static var helenaBackgroundSmallTransparentAccent = Color("General-smallTransparentAccentBackgroundColor", bundle: bundle)
    public static var helenaBackgroundOwnMessage = Color("\(prefix)-ownMessageBackground", bundle: bundle)
    
    // Text
    public static var helenaText = Color("General-textColor", bundle: bundle)
    public static var helenaTextAccent = Color("\(prefix)-accent", bundle: bundle)
    public static var helenaTextAccentLight = Color("\(prefix)-accentLight", bundle: bundle)
    public static var helenaTextLight = Color("General-lightTextColor", bundle: bundle)
    public static var helenaTextSmallAccent = Color("General-smallAccentTextColor", bundle: bundle)
    public static var helenaTextSmallAccentStrong = Color("General-smallAccentStrongTextColor", bundle: bundle)
    
    public static var helenaPlaceholder = Color(UIColor.lightGray)
    public static var helenaError = Color.red
    
    public static var helenaTabIcon = Color("\(prefix)-tapIconColor", bundle: bundle)
    
    // Shadow
    public static var helenaSoftShadow = Color(.sRGBLinear, white: 0, opacity: 0.13)
    
    // Border
    public static var helenaTextViewBorder = Color(UIColor.gray.withAlphaComponent(0.5))
    
}
