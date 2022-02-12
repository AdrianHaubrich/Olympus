//
//  HelenaPhotoPickerButton.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI

public struct HelenaPhotoPickerButton: View {
    
    let limit: Int
    let systemImage: String
    
    @State var photoPickerType: HelenaPhotoPickerType = .selectPhoto
    @State var isImagePickerPresented = false
    @State var selectedImages: [UIImage] = []
    
    var onSelection: (_ image: UIImage) -> ()
    
    public init(_ limit: Int, systemImage: String? = nil, onSelection: @escaping (_ image: UIImage) -> ()) {
        self.limit = limit
        self.systemImage = systemImage ?? "photo.on.rectangle.fill"
        self.onSelection = onSelection
    }
    
    public var body: some View {
        VStack {
            
            // MARK: Fixes
            // Without this, the value of photoPickerType won't change
            if self.photoPickerType == .selectPhoto {
                Text("Fixes Bug in Swift.")
                    .frame(width: .zero, height: .zero)
                    .hidden()
            }
            
            // MARK: Menu
            Menu {
                Button {
                    self.photoPickerType = .selectPhoto
                    self.isImagePickerPresented.toggle()
                } label: {
                    Label("Select Photo", systemImage: "photo.on.rectangle")
                }
                
                Button {
                    self.photoPickerType = .takePhoto
                    self.isImagePickerPresented.toggle()
                } label: {
                    Label("Take Photo", systemImage: "camera")
                }
            } label: {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 27, height: 27)
                    .foregroundColor(.helenaTextAccent)
            }
        }
        // MARK: Sheet
        .sheet(isPresented: $isImagePickerPresented) {
            HelenaPhotoPickerView(self.photoPickerType,
                                  isPresented: $isImagePickerPresented,
                                  limitSelection: (self.limit - self.selectedImages.count))
            { uiImage in
                self.selectImage(uiImage)
            }
        }
    }
}

extension HelenaPhotoPickerButton {
    
    private func selectImage(_ uiImage: UIImage) {
        self.selectedImages.append(uiImage)
        self.onSelection(uiImage)
    }
    
}
