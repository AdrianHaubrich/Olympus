//
//  HelenaFonts.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 25.01.21.
//

import SwiftUI


public struct HelenaFonts {
    
    // Names
    public static let title = "HelveticaNeue"
    public static let defaultF = "HelveticaNeue-Medium"
    
    public static let ultraLight = "HelveticaNeue-UltraLight"
    public static let light = "HelveticaNeue-Light"
    public static let thin = "HelveticaNeue-Thin"
    public static let medium = "HelveticaNeue-Medium"
    public static let bold = "HelveticaNeue-Bold"
    
    // Sizes
    public static let h1: CGFloat = 50
    public static let h2: CGFloat = 45
    public static let h3: CGFloat = 30
    public static let textSize: CGFloat = 17
    public static let describtionSize: CGFloat = 15
    
    
    // MARK: - Special Fonts
    // MARK: Cards
    public static let cardTitle = "AvenirNext-Medium"
    public static let cardTitleSize: CGFloat = 20
    public static let cardUntertitle = "AvenirNext-DemiBold"
    public static let cardUntertitleSize: CGFloat = 12
    public static let cardText = "AvenirNext-Regular"
    public static let cardTextSize: CGFloat = 17
    public static let cardLargeDate = "AvenirNext-Regular"
    public static let cardLargeDateSize: CGFloat = 33
    
    // MARK: Today
    public static let todayWeatherSize: CGFloat = 35
    public static let todayNumberSize: CGFloat = 40
    public static let todayTitleSize: CGFloat = 25
    public static let todayTextSize: CGFloat = 17
    public static let todayIconSize: CGFloat = 22
    
}


// MARK: Types
public enum HelenaFontE {
    case title, cardTitle, lightTitle
    case text, emphasizedText, cardText, cardMediumText
    case small, lightSmall, cardSmall
    case largeInput, cardLarge
    case error
}


public enum FontName: String {
    case title = "HelveticaNeue", cardMedium = "AvenirNext-Medium"
    case ultraLight = "HelveticaNeue-UltraLight"
    case light = "HelveticaNeue-Light"
    case thin = "HelveticaNeue-Thin"
    case medium = "HelveticaNeue-Medium", cardText = "AvenirNext-Regular"
    case bold = "HelveticaNeue-Bold", cardUntertitle = "AvenirNext-DemiBold"
}

public enum FontSize: CGFloat {
    case h1 = 50, h2 = 45, h3 = 30, cardTitleSize = 20
    case textSize = 17
    case describtionSize = 15, cardUntertitleSize = 12
    case largeInputSize = 24, cardLargeDateSize = 33
}


// MARK: Modifier
public struct HelenaFontModifier: ViewModifier {
    
    var font: FontName
    var size: FontSize
    
    public func body(content: Content) -> some View {
        content
            .font(Font.custom(font.rawValue, size: size.rawValue))
    }
    
}


extension View {
    
    public func helenaFont(type: HelenaFontE) -> some View {
        switch type {
            
            // Default
            case .title:
                return self.modifier(HelenaFontModifier(font: .title, size: .h3))
            case .lightTitle:
                return self.modifier(HelenaFontModifier(font: .light, size: .cardTitleSize))
            case .text:
                return self.modifier(HelenaFontModifier(font: .medium, size: .textSize))
            case .small:
                return self.modifier(HelenaFontModifier(font: .bold, size: .describtionSize))
                
            // Cards
            case .cardTitle:
                return self.modifier(HelenaFontModifier(font: .cardMedium, size: .cardTitleSize))
            case .cardText:
                return self.modifier(HelenaFontModifier(font: .cardText, size: .textSize))
            case .cardMediumText:
                return self.modifier(HelenaFontModifier(font: .cardMedium, size: .textSize))
            case .cardSmall:
                return self.modifier(HelenaFontModifier(font: .cardUntertitle, size: .cardUntertitleSize))
            case .cardLarge:
                return self.modifier(HelenaFontModifier(font: .cardText, size: .cardLargeDateSize))
                
            // Special
            case .error:
                return self.modifier(HelenaFontModifier(font: .light, size: .describtionSize))
            case .lightSmall:
                return self.modifier(HelenaFontModifier(font: .light, size: .describtionSize))
            case .largeInput:
                return self.modifier(HelenaFontModifier(font: .medium, size: .largeInputSize))
            case .emphasizedText:
                return self.modifier(HelenaFontModifier(font: .cardUntertitle, size: .textSize))
        }
    }
    
}
