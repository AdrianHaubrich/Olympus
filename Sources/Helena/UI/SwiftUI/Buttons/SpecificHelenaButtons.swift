//
//  SpecificHelenaButtons.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// A button that should be used to navigate back.
public struct HelenaBackButton: View {
    
    // Action
    var action: () -> Void
    
    // Init
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    // Body
    public var body: some View {
        
        Button(action: {
            self.action()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.helenaText)
            }
        }
        
    }
    
}

/// A button that should be used to represent Add-Actions.
public struct HelenaAddButton: View {
    
    // Action
    var action: () -> Void
    
    // Init
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    // Body
    public var body: some View {
        
        Button(action: {
            self.action()
        }) {
            ZStack {
                Circle()
                    .fill(Color.helenaBackground)
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.helenaTextAccent)
                    .font(.system(size: 40))
            }
            .frame(width: 48, height: 48)
        }
    }
}

/// A button that should be used to represent Search-Actions.
public struct HelenaSearchButton: View {
    
    // Action
    var action: () -> Void
    
    // Init
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    // Body
    public var body: some View {
        
        Button(action: {
            self.action()
        }) {
            ZStack {
                Circle()
                    .fill(Color.helenaBackground)
                
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundColor(.helenaTextAccent)
                    .font(.system(size: 40))
            }
            .frame(width: 48, height: 48)
        }
    }
}

/// A button that should be used to represent Enter-Fullscreen-Actions.
public struct HelenaFullscreenButton: View {
    
    // Action
    var action: () -> Void
    
    // Init
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    // Body
    public var body: some View {
        
        Button(action: {
            self.action()
        }) {
            ZStack {
                Circle()
                    .fill(Color.helenaBackground)
                
                Circle()
                    .fill(Color.helenaTextAccent)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundColor(.helenaTextLight)
                    .font(.system(size: 22))
            }
            .frame(width: 48, height: 48)
        }
    }
}

/// A button with two states: selected and not selected.
public struct HelenaSelectionButton: View {
    
    @Binding var selected: Bool
    
    var titleSelected: String
    var titleNotSelected: String
    var systemImageName: String
    
    // Init
    public init(selected: Binding<Bool>, titleSelected: String, titleNotSelected: String, systemImageName: String) {
        self._selected = selected
        self.titleSelected = titleSelected
        self.titleNotSelected = titleNotSelected
        self.systemImageName = systemImageName
    }
    
    public var body: some View {
        ZStack {
            Button(action: {
                self.selected.toggle()
            }) {
                HStack(alignment: .center) {
                    Image(systemName: systemImageName)
                        .foregroundColor(selected ? Color.helenaTextLight : Color.helenaText)
                    Text(selected ? titleSelected + " " : titleNotSelected + " ")
                        .foregroundColor(selected ? Color.helenaTextLight : Color.helenaText)
                }
                .frame(maxWidth: selected ? .infinity : nil)
            }
        }
        .padding(6)
        .background(selected ? Color.helenaTextAccent : Color.helenaBackgroundSmallAccent)
        .cornerRadius(HelenaLayout.cornerRadius)
        .padding([.leading, .trailing], 4)
        .animation(.spring(), value: selected)
        
    }
}
