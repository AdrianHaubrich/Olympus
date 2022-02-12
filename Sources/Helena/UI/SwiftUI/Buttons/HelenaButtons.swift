//
//  HelenaButtons.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// A Button that contans a basic title.
public struct HelenaButton: View {
    
    // Text
    var text: String
    
    // Action
    var action: () -> ()
    
    // Init
    public init(text: String, action: @escaping () -> ()) {
        self.text = text
        self.action = action
    }
    
    // Body
    public var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(self.text)
        }
    }
    
}

/// A Button that takes the full width available.
public struct HelenaFullWidthButton: View {
    
    // Text
    var text: String
    
    // Action
    var action: () -> ()
    
    // Init
    public init(text: String, action: @escaping () -> ()) {
        self.text = text
        self.action = action
    }
    
    // Body
    public var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(self.text)
                .frame(maxWidth: .infinity)
        }
    }
    
}

/// A Button that contans a  title and an image.
public struct HelenaButtonWithIcon: View {
    
    // Text
    var text: String
    var icon: Image
    
    // Action
    var action: () -> Void
    
    // Init
    public init(icon: Image, text: String, action: @escaping () -> ()) {
        self.icon = icon
        self.text = text
        self.action = action
    }
    
    // Body
    public var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                icon
                Text(text)
            }
        }
    }
    
}

/// A Button that takes the full width available. Contains text and an image.
public struct HelenaFullWidthButtonWithIcon: View {
    
    // Text
    var text: String
    var icon: Image
    
    // Action
    var action: () -> Void
    
    // Init
    public init(icon: Image, text: String, action: @escaping () -> ()) {
        self.icon = icon
        self.text = text
        self.action = action
    }
    
    // Body
    public var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                icon
                Text(text)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
}

/// A button that contains a single image.
public struct HelenaIconButton: View {
    
    // Icon
    var icon: Image
    
    // Action
    var action: () -> Void
    
    // Init
    public init(icon: Image, action: @escaping () -> ()) {
        self.icon = icon
        self.action = action
    }
    
    // Body
    public var body: some View {
        
        Button(action: {
            self.action()
        }) {
            HStack {
                icon
                    .foregroundColor(Color(.white))
            }
        }
        
    }
    
}
