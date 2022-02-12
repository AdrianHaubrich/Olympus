//
//  HelenaPhotoPickerView.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI
import PhotosUI

// TODO: Remove public in HelenaPHPicker and HelenaImagePicker -> access only through HelenaPhotoPickerView
public struct HelenaPhotoPickerView: View {
    
    var source: HelenaPhotoPickerType
    @Binding var isPresented: Bool
    var limitSelection: Int
    var onSelection: (UIImage) -> ()
    
    public init(_ source: HelenaPhotoPickerType, isPresented: Binding<Bool>, limitSelection: Int? = nil, onSelection: @escaping (UIImage) -> ()) {
        self.source = source
        self.limitSelection = limitSelection ?? 4
        self.onSelection = onSelection
        self._isPresented = isPresented
    }
    
    public var body: some View {
        if self.source == .selectPhoto {
            HelenaPHPicker(configuration: self.generatePhotoConfig(limit: self.limitSelection),
                           isPresented: self.$isPresented) { uiImage in
                self.onSelection(uiImage)
            }
        } else {
            HelenaImagePicker(sourceType: .camera, allowEditing: true) { uiImage in
                if let uiImage = uiImage {
                    self.onSelection(uiImage)
                }
            }
        }
    }
    
    private func generatePhotoConfig(limit: Int) -> PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = limit
        return config
    }
    
}
