//
//  HelenaTextView.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

#if !os(macOS)
import SwiftUI
import UIKit


/// Implements UITextView in SwiftUI.
public struct HelenaTextView: UIViewRepresentable {
    
    // Text
    @Binding var text: String
    
    // Config
    var fontName: String
    var fontSize: CGFloat
    
    public init(_ text: Binding<String>, fontName: String, fontSize: CGFloat) {
        self._text = text
        self.fontName = fontName
        self.fontSize = fontSize
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        
        //textView.isScrollEnabled = false - prevents line break...
        
        textView.font = UIFont(name: fontName, size: fontSize)
        textView.backgroundColor = UIColor.clear
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.font = UIFont(name: fontName, size: fontSize)
        uiView.text = text
    }
    
    // Coordinator
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: HelenaTextView
        
        public init(_ uiTextView: HelenaTextView) {
            self.parent = uiTextView
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
    
}

public struct HelenaModernTextView: View {
    
    // Values
    var placeholder: String
    
    // Text
    @Binding var text: String
    
    // Init
    public init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    public var body: some View {
        HelenaTextView(self.$text, fontName: FontName.title.rawValue, fontSize: FontSize.textSize.rawValue)
            .frame(minHeight: 100, maxHeight: 100)
            .padding(.top, 5)
            .padding(.leading, -5)
            .background(
                VStack {
                    if self.text == "" {
                        HStack {
                            Text(placeholder)
                                .foregroundColor(Color(.systemGray3))
                            Spacer()
                        }.padding(.top, 15)
                        Spacer()
                    }
                }
            )
    }
}

public struct HelenaModernTextViewWithIcon: View {
    
    // Values
    var iconName: String
    var placeholder: String
    
    // Text
    @Binding var text: String
    
    // Init
    public init(_ placeholder: String, iconName: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.iconName = iconName
        self._text = text
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .padding(.top, 16)
                .padding(.leading)
                .padding(.trailing)
                .padding(.trailing, -12)
            HelenaModernTextView(placeholder, text: $text)
        }.padding(.trailing, 12)
    }
}
#endif
