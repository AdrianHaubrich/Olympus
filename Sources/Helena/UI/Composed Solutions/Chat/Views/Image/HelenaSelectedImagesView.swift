//
//  HelenaSelectedImagesView.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI

public struct HelenaSelectedImagesView: View {
    
    @Binding var images: [UIImage]
    @State var isDetailPresented = false
    @State var selectedImage: UIImage
    let limit: Int
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    public init(images: Binding<[UIImage]>, limit: Int? = nil) {
        self._images = images
        self.selectedImage = images.wrappedValue.first ?? UIImage()
        self.limit = limit ?? 4
    }
    
    public var body: some View {
        
        // Invisible Image fixes bug that prevents from assigning a value to selectedImage (for the first time)
        Image(uiImage: self.selectedImage)
            .frame(width: .zero, height: .zero)
            .hidden()
        
        VStack {
            HStack {
                LazyVGrid(columns: columns) {
                    ForEach(self.images.indices, id: \.self) { index in
                        HelenaSelectedImageElement(self.images[index], index: index, onTap: {
                            withAnimation {
                                self.selectedImage = self.images[index]
                                self.isDetailPresented.toggle()
                            }
                        }, onRemove: {
                            withAnimation {
                                self.removeImage(at: index)
                            }
                        })
                            .transition(AnyTransition.scale)
                            .contextMenu {
                                Button{
                                    withAnimation {
                                        self.removeImage(at: index)
                                    }
                                } label: {
                                    Label("Remove Image", systemImage: "delete.left")
                                }
                            }
                    }
                    
                    if self.images.count < self.limit {
                        HelenaSelectedImageAddElement(limit: self.limit - self.images.count) { image in
                            self.addImage(image: image)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding()
        }
        .background {
            if let uiImage = self.images.first {
                Image(uiImage: uiImage)
                    .resizable()
                    .clipped()
            }
            VisualEffects()
        }
        .fullScreenCover(isPresented: self.$isDetailPresented) {
            HelenaImagesDetailView(isPresented: self.$isDetailPresented, image: self.selectedImage)
        }
    }
    
}

extension HelenaSelectedImagesView {
    
    private func addImage(image: UIImage) {
        self.images.append(image)
    }
    
    private func removeImage(at index: Int) {
        if self.images.count > index {
            self.images.remove(at: index)
        }
    }
    
}
