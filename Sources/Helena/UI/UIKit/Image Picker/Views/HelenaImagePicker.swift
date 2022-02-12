//
//  HelenaImagePicker.swift
//  UniteSwiftUI
//
//  Created by Nico Weigmann on 06.08.20.
//  Copyright © 2020 Adrian Haubrich. All rights reserved.
//

import SwiftUI


public struct HelenaImagePicker: UIViewControllerRepresentable {
    
    // Environment
    @Environment(\.presentationMode) private var presentationMode
    
    // Values
    var sourceType: UIImagePickerController.SourceType
    var allowEditing: Bool
    
    // Actions
    var onDismiss: (UIImage?) -> ()
    
    // Init
    public init(sourceType: UIImagePickerController.SourceType? = nil, allowEditing: Bool? = nil, onDismiss: @escaping (UIImage?) -> ()) {
        self.sourceType = sourceType ?? .photoLibrary
        self.allowEditing = allowEditing ?? false
        self.onDismiss = onDismiss
    }
    
    // MARK: Functions
    public func makeUIViewController(context: UIViewControllerRepresentableContext<HelenaImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = allowEditing
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: HelenaImagePicker
        
        init(_ parent: HelenaImagePicker) {
            self.parent = parent
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
            parent.onDismiss(nil)
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.presentationMode.wrappedValue.dismiss()
                parent.onDismiss(image)
            }
        }
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<HelenaImagePicker>) {}
    
}
