//
//  LocalImageService.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation
import UIKit
import SwiftUI

public struct LocalImageService {
    
    public init() {}
    
}

// MARK: - Path
extension LocalImageService {
    
    /// Converts a String to an URL.
    /// - Parameter fileName: The String that should be convertet to an URL (needs to be unique).
    /// - Returns: A filepath as an URL?
    private func getFilePath(fileName: String) throws -> URL {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            throw LocalImageServiceError.failedToCreateDocumentURL
        }
        return documentURL.appendingPathComponent(fileName + ".png")
    }
    
}


// MARK: - Write
extension LocalImageService {
    
    /// Writes an UIImage to the disk.
    /// - Parameter image: The UIImage to save.
    /// - Parameter fileName: The filename of the image (needs to be unique).
    public func writeToDisk(image: UIImage,
                            fileName: String) async throws {
        
        // Create PNG-Representation
        guard let pngRepresentation = image.pngData() else {
            throw LocalImageServiceError.failedToCreatePNGRepresentation
        }
        
        do {
            // Get path of file
            let filePath = try self.getFilePath(fileName: fileName)
            
            // Write file
            try pngRepresentation.write(to: filePath, options: .atomic)
            
            // Add to User Defaults
            UserDefaultsService.add(fileName, to: .savedImages)
            UserDefaultsService.add(DateHelper.dbString(from: Date()), to: fileName)
            
        } catch {
            print("Error in \(#function) in \(#file): \(error.localizedDescription)")
            throw error
        }
        
    }
    
}

// MARK: - Load
extension LocalImageService {
    
    public func loadImageFromDisk(fileName: String) throws -> UIImage {
        
        do {
            // Get file path
            let filePath = try self.getFilePath(fileName: fileName)
            
            // Load data
            guard let fileData = FileManager.default.contents(atPath: filePath.path) else {
                throw LocalImageServiceError.failedToLoadFileData
            }
            
            // Create UIImage from Data
            guard let image = UIImage(data: fileData) else {
                throw LocalImageServiceError.failedToLoadUIImageFromData
            }
            
            return image
            
        } catch {
            print("Error in \(#function) in \(#file): \(error.localizedDescription)")
            throw error
        }
    }
    
    public func loadImageFromDisk(fileName: String) throws -> Image {
        do {
            let image: UIImage = try self.loadImageFromDisk(fileName: fileName)
            return Image(uiImage: image)
        } catch {
            print("Error in \(#function) in \(#file): \(error.localizedDescription)")
            throw error
        }
    }
    
}

// MARK: - Delete
extension LocalImageService {
    
    /// Deletes an image from the given path.
    /// - Parameter fileName: The name of the image (unique!).
    public func deleteFromDisk(fileName: String) throws {
        
        do {
            
            // Get file path
            let filePath = try self.getFilePath(fileName: fileName)
            
            // Remove file
            try FileManager().removeItem(at: filePath)
            
            // Remove from User Defaults
            UserDefaultsService.remove(for: fileName)
            do { try UserDefaultsService.remove(fileName, with: .savedImages) } catch {}
            
        } catch {
            print("Error in \(#function) in \(#file): \(error.localizedDescription)")
            throw error
        }
    }
    
}
