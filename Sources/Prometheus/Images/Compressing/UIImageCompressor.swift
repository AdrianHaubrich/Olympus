//
//  UIImageCompressor.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation
#if canImport(UIKit)
import UIKit


extension UIImage {
    
    @MainActor
    public func resizeWithPercent(percentage: CGFloat) throws -> UIImage {
        
        // Image View
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        
        // UIGraphicsContext
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            throw UIImageProcessingError.failedToGetCurrentUIGraphicsContext
        }
        imageView.layer.render(in: context)
        
        // Result
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            throw UIImageProcessingError.failedToGetImageFromCurrentUIGraphicsContext
        }
        UIGraphicsEndImageContext()
        
        return result
    }
    
    @MainActor
    public func resizeWithWidth(width: CGFloat) throws -> UIImage {
        
        // Image View
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        
        // UIGraphicsContext
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            throw UIImageProcessingError.failedToGetCurrentUIGraphicsContext
        }
        imageView.layer.render(in: context)
        
        // Result
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            throw UIImageProcessingError.failedToGetImageFromCurrentUIGraphicsContext
        }
        UIGraphicsEndImageContext()
        
        return result
    }
    
    public func compressImage(quality: CGFloat) throws -> UIImage {
        
        guard let compressData = self.jpegData(compressionQuality: quality) else {
            throw UIImageProcessingError.failedToCompressImage
        }
        
        let image = UIImage(data: compressData)
        
        guard let image = image else {
            throw UIImageProcessingError.failedToCreateUIImageFromCompressedData
        }
        return image
    }
    
}
#endif
