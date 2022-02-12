//
//  HelenaChatTextField.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI

/// A texfield with a sendButton that indicates chat-functionality.
public struct HelenaChatTextField: View {
    
    // Data
    @Binding var text: String
    
    // Values
    var imageSelected: Bool
    var imageLimit: Int
    
    // Action
    var sendAction: () -> Void
    var onImageSelection: (_ image: UIImage) -> ()
    
    // Init
    public init(_ text: Binding<String>,
                imageSelected: Bool,
                imageLimit: Int,
                sendAction: @escaping () -> (),
                onImageSelection: @escaping (_ image: UIImage) -> ()) {
        self._text = text
        self.imageSelected = imageSelected
        self.imageLimit = imageLimit
        self.sendAction = sendAction
        self.onImageSelection = onImageSelection
    }
    
    // Body
    public var body: some View {
        HStack {
            if !imageSelected {
                HelenaPhotoPickerButton(self.imageLimit) { image in
                    self.onImageSelection(image)
                }
            }
            HStack {
                TextField("Message", text: $text, onEditingChanged: { isEditing in
                    //...
                }, onCommit: {
                    // ...
                }).foregroundColor(.primary)
                
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(text == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(HelenaLayout.cornerRadius)
            
            if self.text != "" || self.imageSelected {
                Button(action: {
                    self.endEditing(force: true)
                    self.text = ""
                }) {
                    Button(action: {
                        self.sendAction()
                        self.endEditing(force: true)
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.helenaTextLight)
                            .padding(12)
                            .background(Circle().fill(Color.helenaTextAccent))
                    }
                }
            }
        }
        .animation(.default, value: self.text)
        .animation(.default, value: self.imageSelected)
    }
    
    // TODO: Prometheus
    private func endEditing(force: Bool) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
}
