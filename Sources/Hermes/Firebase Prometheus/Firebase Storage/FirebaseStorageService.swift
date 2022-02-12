//
//  FirebaseStorageService.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation
import UIKit
import Combine
import Firebase
import FirebaseStorage
import FirebaseStorageSwift
import Prometheus

public class FirebaseStorageService {
    
    /// Reference to the remote storage.
    let storage: Storage
    let storageRef: StorageReference
    
    let maxFileSize: Int64
    
    public init(bucketURL: String,
                maxFileSize: Int64? = nil) {
        self.storage = Storage.storage()
        self.storageRef = storage.reference(forURL: bucketURL)
        self.maxFileSize = maxFileSize ?? 10 * 1024 * 1024 // 10MB
    }
    
}

// MARK: - Download
extension FirebaseStorageService {
    
    public func subscribe(to fileName: String,
                          in folder: String) -> AnyPublisher<UIImage, Error> {
        
        let subject = PassthroughSubject<UIImage, Error>()
        let localDelay: DispatchTimeInterval = .milliseconds(800)
        let id = UUID().uuidString
        
        if fileName == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + localDelay, execute: {
                self.sendError(subscription: id, with: FirebaseStorageError.invalidFileName)
            })
        }
        
        // System image
        else if let uiImage = UIImage(systemName: fileName) {
            DispatchQueue.main.asyncAfter(deadline: .now() + localDelay, execute: {
                subject.send(uiImage)
                self.cancel(subscription: id)
            })
        }
        
        // Asset
        else if let uiImage = UIImage(named: fileName) {
            DispatchQueue.main.asyncAfter(deadline: .now() + localDelay, execute: {
                subject.send(uiImage)
                self.cancel(subscription: id)
            })
        }
        
        // Cached
        else if let uiImage: UIImage = try? LocalImageService().loadImageFromDisk(fileName: fileName) {
            DispatchQueue.main.asyncAfter(deadline: .now() + localDelay, execute: {
                subject.send(uiImage)
                self.cancel(subscription: id)
            })
        }
        
        // Load from Firebase Storage
        else {
            subscribeToStorage(with: fileName, in: folder)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            self.cancel(subscription: id)
                        case .failure(_):
                            self.sendError(subscription: id, with: FirebaseStorageError.failedToGetImageFromFirebase)
                    }
                }, receiveValue: {
                    if let image = $0 {
                        
                        // Publish result
                        subject.send(image)
                        
                        // Save image locally - cache image
                        Task.detached {
                            await self.saveImageLocally(image, with: fileName)
                        }
                        
                        // Completion
                        self.cancel(subscription: id)
                    } else {
                        self.sendError(subscription: id, with: FirebaseStorageError.failedToGetImageFromFirebase)
                    }
                })
                .store(in: &uiImageTaskCancellables)
        }
        
        // Add to dict
        uiImageTasks[id] = UIImageTask(subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
    private func subscribeToStorage(with fileName: String,
                           in folder: String) -> AnyPublisher<UIImage?, Error> {
        
        let imageRef = self.storageRef.child(folder).child(fileName)
        return FirebaseStorageSubscription
            .subscribe(to: imageRef, with: self.maxFileSize)
            .map {
                return UIImage(data: $0)
            }
            .eraseToAnyPublisher()
    }
    
    private func saveImageLocally(_ image: UIImage, with fileName: String) async {
        try? await LocalImageService().writeToDisk(image: image, fileName: fileName)
    }
    
    private func cancel(subscription id: String) {
        uiImageTasks[id]?.subject.send(completion: .finished)
        uiImageTasks[id] = nil
    }
    
    private func sendError(subscription id: String, with error: Error) {
        uiImageTasks[id]?.subject.send(completion: .failure(error))
        uiImageTasks[id] = nil
    }
    
}

private var uiImageTasks: [String: UIImageTask] = [:]
private var uiImageTaskCancellables: Set<AnyCancellable> = []
private struct UIImageTask {
    let subject: PassthroughSubject<UIImage, Error>
}


// MARK: - Upload
extension FirebaseStorageService {
    
    /// Uploads an image to FirebaseStorage.
    ///
    /// - Parameters:
    ///   - image: The image that should be saved.
    ///   - fileName: The fileName the image should be saved with.
    ///   - folder: The name of the folder within the bucket, where the image should be saved.
    ///   - compressWidth: The width the image should be compressed to (default: 500).
    ///   - maxCompressQuality: The highest valid compression quality (default: 0.5).
    @discardableResult
    public func uploadImage(_ image: UIImage,
                     fileName: String,
                     folder: String,
                     compressWidth: CGFloat? = nil,
                     maxCompressQuality: CGFloat? = nil) async throws -> StorageMetadata {
        
        let imageRef = self.storageRef
            .child(folder)
            .child(fileName)
        
        let compressWidh = compressWidth ?? 500
        let maxCompressQuality = maxCompressQuality ?? 0.5
        
        do {
            // Compress
            var compressedImage = try await image.resizeWithWidth(width: compressWidh)
            compressedImage = try image.compressImage(quality: maxCompressQuality)
            
            // Check image size & recompress if necessary -> min. compress Quality is 10%
            if var smallImageSize = compressedImage.pngData()?.count {
                var compressQuality: CGFloat = 0.4
                while smallImageSize > self.maxFileSize && compressQuality >= 0.2 {
                    compressedImage = try compressedImage.compressImage(quality: compressQuality)
                    smallImageSize = compressedImage.pngData()?.count ?? 0
                    compressQuality -= 0.1
                }
                
                if smallImageSize > self.maxFileSize {
                    throw FirebaseStorageError.failedToCompressImage
                }
            } else {
                throw FirebaseStorageError.failedToCalculateImageSize
            }
            
            // Transform image to png-data
            guard let imageData = compressedImage.pngData() else {
                throw FirebaseStorageError.failedToTransformImageToData
            }
            
            // Upload file
            return try await imageRef.putDataAsync(imageData, metadata: nil)
            
        } catch {
            print("Error in \(#function) in \(#file): \(error.localizedDescription)")
            throw error
        }
    }
    
}

// MARK: - Delete
extension FirebaseStorageService {
    
    /// Removes an image from the remote storage
    /// - Parameters:
    ///   - imagePath: Path of the image to remove
    ///   - completion: The completion handler returning a boolean value indicating whether the image could be removed successfully.
    public func deleteFile(fileName: String,
                     folder: String) async throws {
        
        let fileRef = self.storageRef
            .child(folder)
            .child(fileName)
        
        // Delete file
        return try await fileRef.delete()
    }
    
}
