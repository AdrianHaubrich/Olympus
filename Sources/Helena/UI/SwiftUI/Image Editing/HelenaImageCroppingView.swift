//
//  HelenaImageCroppingView.swift
//
//
//  Created by Nico Weigmann on 08.02.21.
//

import SwiftUI

public struct HelenaImageCroppingViewWrapper: View {

    // Data
    var image: UIImage

    // Values
    @State var offset: CGSize?
    @State var magnification: CGFloat?

    // Actions
    var onDismiss: (UIImage?) -> ()

    // Init
    public init(image: UIImage, offset: CGSize? = nil, scale: CGFloat? = nil, onDismiss: @escaping (UIImage?) -> ()) {
        self.image = image
        self._offset = State(initialValue: offset)
        self._magnification = State(initialValue: scale)
        self.onDismiss = onDismiss
    }

    public var body: some View {
        NavigationView {
            GeometryReader { g in
                HelenaImageCroppingView(image: image, offset: offset, scale: magnification, g: g, onDismiss: onDismiss)
            }
        }
    }
}

// MARK: -

public struct HelenaImageCroppingView: View {

    // Environment
    @Environment(\.presentationMode) private var presentationMode

    // Data
    var image: UIImage

    // Values
    var screenWidth: CGFloat
    var resizedImageWidth: CGFloat
    var resizedImageHeight: CGFloat
    @State var offset: CGSize
    @State var currentOffset: CGSize
    @State var magnification: CGFloat
    @State var currentMagnification: CGFloat

    // Constants
    private static let MIN_MAGNIFICATION: CGFloat = 1
    private static let MAX_MAGNIFICATION: CGFloat = 3
    
    /// - Warning: Depends on current magnification. Run updateOffsetLimits() after magnification.
    private static var MIN_OFFSET: CGSize = .zero
    
    /// - Warning: Depends on current magnification. Run updateOffsetLimits() after magnification.
    private static var MAX_OFFSET: CGSize = .zero

    // Actions
    var onDismiss: (UIImage?) -> ()

    // Init
    public init(image: UIImage, offset: CGSize? = nil, scale: CGFloat? = nil, g: GeometryProxy, onDismiss: @escaping (UIImage?) -> ()) {
        self.image = image

        self.screenWidth = g.size.width

        if image.size.width > image.size.height {
            resizedImageHeight = screenWidth
            resizedImageWidth = image.size.width * resizedImageHeight / image.size.height
        } else if image.size.width < image.size.height {
            resizedImageWidth = screenWidth
            resizedImageHeight = image.size.height * resizedImageWidth / image.size.width
        } else {
            resizedImageWidth = screenWidth
            resizedImageHeight = resizedImageWidth
        }

        self._offset = State(initialValue: offset ?? .zero)
        self._currentOffset = self._offset
        self._magnification = State(initialValue: scale ?? HelenaImageCroppingView.MIN_MAGNIFICATION)
        self._currentMagnification = self._magnification

        self.onDismiss = onDismiss

        // Update offset limits
        self.updateOffsetLimits()
    }

    public var body: some View {
        VStack {
            Spacer()
            HelenaRoundImageCropping(image: Image(uiImage: image), rect: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth), scale: currentMagnification, offset: currentOffset)
                .clipShape(Rectangle())
                .gesture(scaleGesture)
                .highPriorityGesture(dragGesture)
            Spacer()
        }
        .padding(.bottom, 24)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Move and Scale")
        .navigationBarItems(leading:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                    onDismiss(nil)
                                }, label: {
                                    Text("Cancel")
                                        .foregroundColor(Color.helenaTextAccent)
                                        .fontWeight(.regular)
                                }), trailing:
                                    Button(action: {
                                        saveAction()
                                    }, label: {
                                        Text("Choose")
                                            .foregroundColor(Color.helenaTextAccent)
                                            .fontWeight(.bold)
                                    })
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Gestures

extension HelenaImageCroppingView {

    private var scaleGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                currentMagnification = magnification * value
            }
            .onEnded { _ in
                // limit magnification
                limitMagnification()
                updateOffsetLimits()
                limitOffset()
            }
    }

    private var dragGesture: some Gesture {

        DragGesture()
            .onChanged { value in
                currentOffset = CGSize(
                    width: offset.width + value.translation.width,
                    height: offset.height + value.translation.height
                )
            }
            .onEnded { _ in
                // limit offset
                limitOffset()
            }
    }
}

// MARK: - Functions

extension HelenaImageCroppingView {
    
    private func saveAction() {
        presentationMode.wrappedValue.dismiss()
        let adjustedOffset = CGSize(width: offset.width * image.size.width / resizedImageWidth, height: offset.height * image.size.height / resizedImageHeight)
        let editedImage = image.cropImage(rect: CGRect(x: adjustedOffset.width, y: adjustedOffset.height, width: image.size.width, height: image.size.height), magnification: magnification) ?? UIImage()
        onDismiss(editedImage)
    }
    
    private func limitMagnification() {
        if currentMagnification > HelenaImageCroppingView.MIN_MAGNIFICATION && currentMagnification < HelenaImageCroppingView.MAX_MAGNIFICATION {
            magnification = currentMagnification
        } else if currentMagnification > HelenaImageCroppingView.MAX_MAGNIFICATION {
            currentMagnification = HelenaImageCroppingView.MAX_MAGNIFICATION
            magnification = currentMagnification
        } else {
            currentMagnification = HelenaImageCroppingView.MIN_MAGNIFICATION
            magnification = currentMagnification
        }
    }
    
    private func updateOffsetLimits() {
        HelenaImageCroppingView.MIN_OFFSET = CGSize(
            width: (-(resizedImageWidth * self.currentMagnification - self.screenWidth) / 2),
            height: (-(resizedImageHeight * self.currentMagnification - self.screenWidth) / 2)
        )
        HelenaImageCroppingView.MAX_OFFSET = CGSize(
            width: ((resizedImageWidth * self.currentMagnification - self.screenWidth)  / 2),
            height: ((resizedImageHeight * self.currentMagnification - self.screenWidth) / 2)
        )
    }
    
    private func limitOffset() {
        if currentOffset.width > HelenaImageCroppingView.MIN_OFFSET.width && currentOffset.width < HelenaImageCroppingView.MAX_OFFSET.width {
            if currentOffset.height > HelenaImageCroppingView.MIN_OFFSET.height && currentOffset.height < HelenaImageCroppingView.MAX_OFFSET.height {
                offset = currentOffset
            } else if currentOffset.height < HelenaImageCroppingView.MIN_OFFSET.height {
                currentOffset = CGSize(width: currentOffset.width, height: HelenaImageCroppingView.MIN_OFFSET.height)
                offset = currentOffset
            } else {
                currentOffset = CGSize(width: currentOffset.width, height: HelenaImageCroppingView.MAX_OFFSET.height)
                offset = currentOffset
            }
        } else if currentOffset.width < HelenaImageCroppingView.MIN_OFFSET.width {
            if currentOffset.height > HelenaImageCroppingView.MIN_OFFSET.height && currentOffset.height < HelenaImageCroppingView.MAX_OFFSET.height {
                currentOffset = CGSize(width: HelenaImageCroppingView.MIN_OFFSET.width, height: currentOffset.height)
                offset = currentOffset
            } else if currentOffset.height < HelenaImageCroppingView.MIN_OFFSET.height{
                currentOffset = CGSize(width: HelenaImageCroppingView.MIN_OFFSET.width, height: HelenaImageCroppingView.MIN_OFFSET.height)
                offset = currentOffset
            } else {
                currentOffset = CGSize(width: HelenaImageCroppingView.MIN_OFFSET.width, height: HelenaImageCroppingView.MAX_OFFSET.height)
                offset = currentOffset
            }
        } else {
            if currentOffset.height > HelenaImageCroppingView.MIN_OFFSET.height && currentOffset.height < HelenaImageCroppingView.MAX_OFFSET.height {
                currentOffset = CGSize(width: HelenaImageCroppingView.MAX_OFFSET.width, height: currentOffset.height)
                offset = currentOffset
            } else if currentOffset.height < HelenaImageCroppingView.MIN_OFFSET.height {
                currentOffset = CGSize(width: HelenaImageCroppingView.MAX_OFFSET.width, height: HelenaImageCroppingView.MIN_OFFSET.height)
                offset = currentOffset
            } else {
                currentOffset = CGSize(width: HelenaImageCroppingView.MAX_OFFSET.width, height: HelenaImageCroppingView.MAX_OFFSET.height)
                offset = currentOffset
            }
        }
    }
}

//extension HelenaImageCroppingView {
//
//    /// Crops an image according to the given parameters.
//    /// - Parameters:
//    ///   - rect: Sets the image section
//    ///   - magnification: Sets the image magnification
//    /// - Returns: The cropped image as UIImage?
//    private func cropImage() -> UIImage? {
//        if let cgImage = image.cgImage {
//            let scaler = CGFloat(cgImage.width)/resizedImageWidth
//            let dimension
//            cgImage.cropping(to: rect)
//            let croppedImage: UIImage? = UIImage(cgImage: cgImage)
//            return croppedImage
//        } else {
//            return image
//        }
//
//    }
//
//}

extension UIImage {

    /// Crops an image according to the given parameters.
    /// - Parameters:
    ///   - rect: Sets the image section
    ///   - magnification: Sets the image magnification
    /// - Returns: The cropped image as UIImage?
    public func cropImage(rect: CGRect, magnification: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / magnification, height: rect.size.height / magnification), true, 0.0)

        // draw the image from top left corner
        self.draw(at: CGPoint(x: -rect.origin.x / magnification, y: -rect.origin.y / magnification))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return croppedImage
    }

}
