//
//  LocalImageServiceError.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation

enum LocalImageServiceError: String, Error {
    case failedToCreateDocumentURL = "Failed to create the document url."
    case failedToCreateFilePath = "Failed to create the file path."
    
    case failedToCreatePNGRepresentation = "Failed to create PNG-Representation."
    
    case failedToLoadFileData = "Failed to load file-data from file-system."
    case failedToLoadUIImageFromData = "Failed to load UIImage from Data."
}
