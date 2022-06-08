//
//  HelenaPreviewContextMenu.swift
//  
//
//  Created by Adrian Haubrich on 06.11.21.
//

import SwiftUI

#if os(macOS)
import MacOSCompatibility
#else
import UIKit
#endif

public struct HelenaPreviewContextMenu<Content: View> {
    let destination: Content
    let actionProvider: UIContextMenuActionProvider?
    
    public init(destination: Content, actionProvider: UIContextMenuActionProvider? = nil) {
        self.destination = destination
        self.actionProvider = actionProvider
    }
}

public struct HelenaPreviewContextView<Content: View>: UIViewRepresentable {
    
    let menu: HelenaPreviewContextMenu<Content>
    let didCommitView: () -> Void
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(menu: self.menu, didCommitView: self.didCommitView)
    }
    
    public class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        
        let menu: HelenaPreviewContextMenu<Content>
        let didCommitView: () -> Void
        
        init(menu: HelenaPreviewContextMenu<Content>, didCommitView: @escaping () -> Void) {
            self.menu = menu
            self.didCommitView = didCommitView
        }
        
        public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
                UIHostingController(rootView: self.menu.destination)
            }, actionProvider: self.menu.actionProvider)
        }
        
        public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            animator.addCompletion(self.didCommitView)
        }
        
    }
}

// MARK: - Modifier
extension View {
    public func contextMenu<Content: View>(_ menu: HelenaPreviewContextMenu<Content>) -> some View {
        self.modifier(PreviewContextViewModifier(menu: menu))
    }
}

public struct PreviewContextViewModifier<V: View>: ViewModifier {
    
    let menu: HelenaPreviewContextMenu<V>
    @Environment(\.presentationMode) var mode
    
    @State var isActive: Bool = false
    
    public func body(content: Content) -> some View {
        Group {
            if isActive {
                menu.destination
            } else {
                content.overlay(HelenaPreviewContextView(menu: menu, didCommitView: { self.isActive = true }))
            }
        }
    }
}
