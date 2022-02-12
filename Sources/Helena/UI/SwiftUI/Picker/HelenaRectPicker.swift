//
//  HelenaRectPicker.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaRectPicker: View {
    
    @Binding var selectedIndex: Int
    var options: [String]
    
    public init(selectedIndex: Binding<Int>, options: [String]) {
        self._selectedIndex = selectedIndex
        self.options = options
    }
    
    public var body: some View {
        
        HStack {
            ForEach(options.indices, id: \.self) { index in
                HelenaPickerRect(text: options[index], index: index, selectedIndex: $selectedIndex)
            }
        }
        
    }
    
}

struct HelenaPickerRect: View {
    
    // Data
    var text: String
    
    var index: Int
    @Binding var selectedIndex: Int
    
    // Body
    var body: some View {
        HelenaCard(backgroundColors: selectedIndex == index ? [Color.helenaTextAccent] : [], hasShadow: (selectedIndex == index)) {
            GeometryReader { m in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text(text)
                            .helenaFont(type: .emphasizedText)
                            .foregroundColor(selectedIndex == index ? Color.helenaTextLight : Color.helenaText)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .frame(height: 50)
        }
        .animation(.easeInOut, value: selectedIndex)
        .onTapGesture {
            withAnimation {
                selectedIndex = index
            }
        }
    }
    
}
