//
//  UIImageProcessingError.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation

enum UIImageProcessingError: String, Error {
    case failedToGetCurrentUIGraphicsContext = "Failed to get current UIGraphicsContext"
    case failedToGetImageFromCurrentUIGraphicsContext = "Failed to get image from current UIGraphicsContext"
    
    case failedToCompressImage = "Failed to compress image."
    case failedToCreateUIImageFromCompressedData = "Failed to create UIImage from compresses data."
}
