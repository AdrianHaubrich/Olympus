//
//  HelenaErrorMessage.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaInlineErrorMessage: View {
    
    // Text
    var text: String
    
    // Init
    public init(_ text: String) {
        self.text = text
    }
    
    // Body
    public var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "exclamationmark.triangle")
                Text(text)
                    .helenaFont(type: .error)
            }.foregroundColor(Color.helenaError)
        }
        
    }
    
}
