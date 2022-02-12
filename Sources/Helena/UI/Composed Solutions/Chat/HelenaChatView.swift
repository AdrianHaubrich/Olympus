//
//  HelenaChatView.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI

public struct HelenaChatView: View {
    
    var messages: [HelenaChatMessage]
    let onSend: (_ text: String? , _ images: [UIImage]?) -> ()
    
    @State var text = ""
    @State var selectedImages: [UIImage] = []
    
    let imageLimit = 4
    
    public init(messages: [HelenaChatMessage],
                onSend: @escaping (_ text: String? , _ images: [UIImage]?) -> ()) {
        self.messages = messages
        self.onSend = onSend
    }
    
    public var body: some View {
        VStack {
            
            // TODO: Show Messages...
            Text("Hello, World!")
            Spacer()
            
            if !selectedImages.isEmpty {
                HelenaSelectedImagesView(images: self.$selectedImages, limit: self.imageLimit)
            }
            
            Divider()
                .padding([.top], -8)
            
            HelenaChatTextField($text, imageSelected: !selectedImages.isEmpty,
                                imageLimit: self.imageLimit,
                                sendAction: {
                self.onSend(self.text, selectedImages)
            }, onImageSelection: { image in
                self.selectImage(image)
            })
                .padding([.horizontal, .bottom])
            
        }
        
    }
    
}

extension HelenaChatView {
    
    private func selectImage(_ uiImage: UIImage) {
        self.selectedImages.append(uiImage)
    }
    
}
