//
//  HelenaSelectedImageElement.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI

struct HelenaSelectedImageElement: View {
    
    let uiImage: UIImage
    let onTap: () -> ()
    let onRemove: () -> ()
    private let index: Int
    
    init(_ uiImage: UIImage, index: Int, onTap: @escaping () -> (), onRemove: @escaping () -> ()) {
        self.uiImage = uiImage
        self.onTap = onTap
        self.onRemove = onRemove
        self.index = index
    }
    
    var body: some View {
        
        ZStack {
            
            // Image
            VStack {
                GeometryReader { m in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: m.size.width)
                        .position(x: m.frame(in: .local).midX, y: m.frame(in: .local).midY)
                        .cornerRadius(HelenaLayout.cornerRadius)
                        .shadow(radius: HelenaLayout.shadowRadius)
                        .contentShape(Rectangle()) // Restricts tappable area
                        .onTapGesture {
                            self.onTap()
                        }
                }
                .clipped()
                .cornerRadius(HelenaLayout.cornerRadius)
                .aspectRatio(1, contentMode: .fit)
            }
            
            // Remove Button
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        VisualEffects()
                        Image(systemName: "xmark")
                    }
                    .frame(width: 30, height: 30)
                    .clipped()
                    .cornerRadius(15)
                }
                .onTapGesture {
                    // Remove Image
                    withAnimation {
                        self.onRemove()
                    }
                }
                Spacer()
            }
            .offset(x: 6, y: -6)
        }
        
    }
    
}
