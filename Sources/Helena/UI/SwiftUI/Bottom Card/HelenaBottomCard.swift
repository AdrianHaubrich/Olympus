//
//  HelenaBottomCard.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// A fully working implementation of a bottom sheet.
///
/// Due to SwiftUI restrictions a navigation inside the sheed is nearly impossible and should be avoided.
public struct HelenaFullScreenBottomCard<Content: View>: View {
    
    // Set state
    @Binding var isOpen: Bool
    
    // Gesture State
    @GestureState private var dragState = DragState.inactive
    
    // Inner View
    var content: Content
    
    // Height
    var minHeight: CGFloat
    var maxHeight: CGFloat
    
    // Offset
    @State var offset: CGFloat = 0
    
    // Init
    public init(isOpen: Binding<Bool>, minHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self._isOpen = isOpen
        self.content = content()
        
        if !self._isOpen.wrappedValue {
            offset = maxHeight - minHeight
        } else {
            offset = 0
        }
    }
    
    // Body
    public var body: some View {
        
        // Drag
        let drag = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
                print("Updating: ", self.offset + self.dragState.translation.height)
            }
            .onEnded(onDragEnded)
        
        
        // Sheet
        return GeometryReader { m in
            VStack {
                RoundedRectangle(cornerRadius: HelenaLayout.cornerRadius)
                    .fill(Color.secondary)
                    .frame(width: 60, height: 6)
                    .padding(.top, 12)
                Spacer(minLength: 0)
                self.content
            }
            .frame(width: m.size.width, height: m.size.height - 25)
            .background(Color.helenaBackground)
            .cornerRadius(HelenaLayout.cornerRadius, corners: [.topLeft, .topRight])
            .shadow(color: Color.helenaSoftShadow, radius: HelenaLayout.cornerRadius)
            .offset(y: self.checkOffset())
            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: offset)
            .onTapGesture {}
            .gesture(drag)
        }
        
    }
    
}

extension HelenaFullScreenBottomCard {
    private func onDragEnded(drag: DragGesture.Value) {
        
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        
        print("isDragging?: \(self.dragState.isDragging)")
        
        if verticalDirection > 0 {
            self.isOpen = false
            self.offset = maxHeight - minHeight
            print("Close with offset: \(self.offset)")
        } else if verticalDirection < 0 {
            self.isOpen = true
            self.offset = 0
            print("Open with offset: \(self.offset)")
        }
        
    }
    
    private func checkOffset() -> CGFloat {
        let height = self.offset + self.dragState.translation.height
        let margin: CGFloat = 20 // Drag over/under min/maxiumum to make it feel more natural
        
        if height - margin > self.maxHeight - self.minHeight {
            // Drag under minimum
            return (self.maxHeight - self.minHeight) + margin
        } else if height /*+ margin*/ < 0 {
            // Drag over maximum
            return 0 /*- margin*/
        }
        return height
    }
}

enum DragState {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
            case .inactive:
                return false
            case .dragging:
                return true
        }
    }
}
