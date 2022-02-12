//
//  HelenaImageCollage.swift
//  
//
//  Created by Adrian Haubrich on 31.10.21.
//

import SwiftUI

public struct HelenaImageCollage: View {
    
    private var images : [Image]
    private var collageImages: [CollageImage]
    private var showShadow: Bool
    
    private let limit = 3
    
    // Columns
    var columns = [
        GridItem(.flexible(), spacing: 0)
    ]
    
    
    // Init
    public init(_ images: [Image], showShadow: Bool? = nil) {
        
        self.images = images
        self.showShadow = showShadow ?? false
        
        self.collageImages = images.map {
            return CollageImage(image: $0)
        }
        
        if self.collageImages.count > limit + 1 && limit != 0 {
            self.collageImages.removeSubrange(limit...)
        }
        
        // Grid items
        if self.collageImages.count > 1 {
            self.columns.append(GridItem(.flexible(), spacing: 0))
        }
        
        if self.images.count == 3 {
            self.columns.append(GridItem(.flexible(), spacing: 0))
        }
    }
    
    // Body
    public var body: some View {
        VStack {
            LazyVGrid(columns: self.columns, spacing: 0) {
                ForEach(self.collageImages.indices) { index in
                    formatImage(self.collageImages[index])
                }
                if images.count > limit + 1 {
                    ZStack {
                        formatImage(CollageImage(image: self.images[limit]), padding: 0)
                            .blur(radius: 10)
                            .clipped()
                            .cornerRadius(HelenaLayout.cornerRadius)
                            .padding(2)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("+\(self.images.count - self.collageImages.count)")
                                    .foregroundColor(.helenaTextLight)
                                    .helenaFont(type: .title)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(2)
            .background {
                Rectangle().fill(Color.helenaBackground)
            }
        }
        .cornerRadius(HelenaLayout.cornerRadius)
        .shadow(radius: self.showShadow ? 5 : 0)
    }
}

extension HelenaImageCollage {
    
    private func formatImage(_ image: CollageImage, padding: CGFloat? = nil) -> some View {
        return image.image
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .cornerRadius(HelenaLayout.cornerRadius)
            .padding(padding ?? 2)
    }
    
    private struct CollageImage: Identifiable {
        let id = UUID()
        let image: Image
    }
    
}
