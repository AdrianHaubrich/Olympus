//
//  HelenaTextField.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 25.01.21.
//

import SwiftUI


public struct HelenaTextField: View {
    
    // Values
    var placeholder: String
    @Binding var text: String
    
    var isSecure: Bool
    var keyboardType: UIKeyboardType
    var showError: Bool
    var errorMessage: String
    
    var fontType: HelenaFontE
    var iconName: String?
    
    /// The default TextField.
    ///
    /// The usage of an icon is strongly encuraged. Besides improving the layout, it
    /// tells the user that and also what he is supposed to enter.
    ///
    /// - Parameters:
    ///   - placeholder: The placeholder String.
    ///   - text: The text typed in the TextField.
    ///   - isSecure: Secure-Entry-Enabled
    ///   - keyboardType: The type of the keyboard: eg: number, phone, email
    ///   - showError: Whether the error message is shown.
    ///   - errorMessage: The error message shown. Keep this empty to show the default error
    ///   message. The default message can be configued through HelenaCentralConfig.
    ///   - isLarge: Wheather the TextField size should be normal or large. Use large
    ///   if the TextField is one of the main UI-Elements in the View.
    ///   - iconName: The system-image-name of the icon. Keep this empty if you don't want
    ///   to use an icon.
    public init(_ placeholder: String, text: Binding<String>, isSecure: Bool? = nil, keyboardType: UIKeyboardType? = nil, showError: Bool? = nil, errorMessage: String? = nil, isLarge: Bool? = nil, iconName: String? = nil) {
        
        self.placeholder = placeholder
        self._text = text
        
        self.isSecure = isSecure ?? false
        self.keyboardType = keyboardType ?? .default
        
        self.showError = showError ?? false
        self.errorMessage = errorMessage ?? HelenaCentralConfig.shared.defaultErrorMessage
        
        if (isLarge ?? false) {
            fontType = .largeInput
        } else {
            fontType = .text
        }
        
        self.iconName = iconName
        
    }
    
    // Body
    public var body: some View {
        HStack {
            // Icon
            if let iconName = iconName {
                Image(systemName: iconName).foregroundColor(.gray)
                    .padding()
                    .padding(.trailing, -12)
            }
            
            // Text
            VStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .helenaFont(type: fontType)
                } else {
                    TextField(placeholder, text: $text)
                        .helenaFont(type: fontType)
                }
                
                if showError {
                    HelenaInlineErrorMessage(errorMessage)
                }
            }
        }
    }
    
}


// MARK: - Preview
struct HelenaTextField_Previews: PreviewProvider {
    
    @State private static var text = ""
    @State private static var imageSelected = false
    
    static var previews: some View {
        HelenaTextField("Placeholder", text: $text)
            .padding()
    }
}
