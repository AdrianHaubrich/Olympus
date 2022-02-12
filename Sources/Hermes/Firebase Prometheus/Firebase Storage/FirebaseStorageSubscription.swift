//
//  FirebaseStorageSubscription.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Combine
import FirebaseStorage
import FirebaseStorageSwift
import UIKit

struct FirebaseStorageSubscription {}

// MARK: - Subscribe to getData
extension FirebaseStorageSubscription {
    
    static func subscribe(to storageRef: StorageReference, with maxFileSize: Int64) -> AnyPublisher<Data, Error> {
        
        let subject = PassthroughSubject<Data, Error>()
        let id = UUID().uuidString
        
        // Download in memory with a maximum allowed size
        let task = storageRef.getData(maxSize: maxFileSize) { data, error in
            
            guard let data = data else {
                sendError(id: id, with: error ?? FirebaseStorageError.failedToGetImageFromFirebase)
                return
            }
            
            subject.send(data)
            self.cancel(id: id)
        }
        
        // Add to dict
        storageTasks[id] = StorageTask(reference: storageRef, task: task, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
}

extension FirebaseStorageSubscription {
    
    static func cancel(id: String) {
        storageTasks[id]?.subject.send(completion: .finished)
        storageTasks[id]?.task.cancel()
        storageTasks[id] = nil
    }
    
    static func sendError(id: String, with error: Error) {
        storageTasks[id]?.subject.send(completion: .failure(error))
        storageTasks[id]?.task.cancel()
        storageTasks[id] = nil
    }
    
}


private var storageTasks: [String: StorageTask] = [:]

private struct StorageTask {
    let reference: StorageReference
    let task: StorageDownloadTask
    let subject: PassthroughSubject<Data, Error>
}
