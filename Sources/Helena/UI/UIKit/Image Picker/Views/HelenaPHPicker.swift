//
//  HelenaPHPicker.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 30.10.21.
//

import SwiftUI
import PhotosUI

public struct HelenaPHPicker: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    let configuration: PHPickerConfiguration
    let onSelection: (_ uiImage: UIImage) -> ()
    
    @State var pickerResult: [UIImage] = []
    
    public init(configuration: PHPickerConfiguration, isPresented: Binding<Bool>, onSelection: @escaping (_ uiImage: UIImage) -> ()) {
        self.configuration = configuration
        self._isPresented = isPresented
        self.onSelection = onSelection
    }
    
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// PHPickerViewControllerDelegate => Coordinator
    public class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: HelenaPHPicker
        
        init(_ parent: HelenaPHPicker) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // Add selected images
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self)  {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            self.parent.pickerResult.append(newImage as! UIImage)
                            
                            // Return result
                            self.parent.onSelection(newImage as! UIImage)
                        }
                    }
                } else {
                    print("Loaded Assest is not a Image")
                }
            }
            
            // Dissmiss
            parent.isPresented = false
        }
    }
}


