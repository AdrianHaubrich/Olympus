//
//  FirestoreChatServiceError.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation

enum FirestoreChatServiceError: String, Error {
    case noImagesToLoad = "No images to load."
    case invalidImagePath = "Invalid image path."
}
