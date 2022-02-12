//
//  FirebaseStorageError.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation

enum FirebaseStorageError: String, Error {
    case invalidFileName = "The name of the file is invalid."
    case failedToGetImageFromFirebase = "Failed to get image from firebase."
    
    case failedToCompressImage = "Failed to compress image."
    case imageToLargeAfterCompression = "The image size is to high."
    case failedToCalculateImageSize = "The image size couldn't be calculated."
    case failedToTransformImageToData = "Failed to transform image to png-data."
    
    case failedUpload = "The upload failed."
}
