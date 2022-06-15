//
//  FirestoreChatService.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import PrometheusFirebaseStorage
import PrometheusFirestore

class FirestoreChatService: ChatService {
    
    var type: ChatServiceType
    
    var currentUserID: String
    var currentUserName: String
    
    // Lazy Fetching - Pointer for next fetch
    var lastChatDoc: DocumentSnapshot?
    var lastMessageDoc: DocumentSnapshot?
    
    let bucketURL: String
    let CHAT_STORAGE_FOLDER = "chat"
    
    // Init
    init(currentUserID: String, currentUserName: String, bucketURL: String) {
        self.type = .firestore(uid: currentUserID, username: currentUserName, bucketURL: bucketURL)
        self.currentUserID = currentUserID
        self.currentUserName = currentUserName
        self.bucketURL = bucketURL
    }
    
}

// MARK: - Fetch
extension FirestoreChatService {
    
    func fetchChat(by chatID: String) async -> Chat? {
        do {
            
            let chat = try await FirestoreChatReferenceFactory
                .generateChatReference(by: chatID)
                .getDocument()
                .data(as: Chat.self)
            
            return chat
            
        } catch {
            print("Error in FirestoreChatService: " + error.localizedDescription)
            return nil
        }
    }
    
    func fetchNextChats(by uid: String,
                        with limit: Int?) async -> [Chat]? {
        do {
            
            let snapshot = try await FirestoreChatReferenceFactory
                .generateChatsQuery(by: uid, with: limit, start: self.lastChatDoc)
                .getDocuments()
            
            // Set Pointer for next fetch
            self.lastChatDoc = snapshot.documents.last
            
            let chats = try snapshot.documents.map {
                try $0.data(as: Chat.self)
            }
            
            return chats
            
        } catch {
            print("Error in FirestoreChatService: " + error.localizedDescription)
            return nil
        }
    }
    
    func fetchNextMessages(for chatID: String,
                           with limit: Int?) async -> [Message]? {
        do {
            
            let snapshot = try await FirestoreChatReferenceFactory
                .generateMessagesQuery(for: chatID, with: limit, start: self.lastMessageDoc)
                .getDocuments()
            
            // Set Pointer for next fetch
            self.lastMessageDoc = snapshot.documents.last
            
            let messages = try snapshot.documents.map {
                try $0.data(as: Message.self)
            }
            
            return messages
            
        } catch {
            print("Error in FirestoreChatService: " + error.localizedDescription)
            return nil
        }
    }
    
    // Not used and not in protocol...
    private func fetchMessage(by chatID: String,
                              and messageID: String) async -> Message? {
        do {
            
            let message = try await FirestoreChatReferenceFactory
                .generateMessageReference(by: chatID, and: messageID)
                .getDocument()
                .data(as: Message.self)
            
            return message
            
        } catch {
            print("Error in FirestoreChatService: " + error.localizedDescription)
            return nil
        }
    }
    
}

// MARK: - Listen
extension FirestoreChatService {
    
    /// Returns all new and changed messages
    func subscribe(to chatID: String) -> AnyPublisher<[Message?], Never> {
        
        let query = FirestoreChatReferenceFactory
            .generateMessagesQuery(for: chatID, descending: false, inFuture: true)
        
        // Transform AnyPublisher<[DocumentSnapshot], Never> to AnyPublisher<[Message], Never>
        return FirestoreSubscription
            .subscribe(to: query, with: chatID)
            .map {
                do {
                    let messages = try $0.documentChanges.map {
                        try $0.document.data(as: Message.self)
                    }
                    return messages
                } catch {
                    print("Error while trying to map document to Message: \(error.localizedDescription)")
                    return []
                }
            }
            .eraseToAnyPublisher()
    }
    
    func subscribeImages(for message: Message) throws -> AnyPublisher<Message, Error> {
        
        let subject = PassthroughSubject<Message, Error>()
        var message = message
        
        guard let images = message.images else {
            throw FirestoreChatServiceError.noImagesToLoad
        }
        
        for image in images {
            FirebaseStorageService(bucketURL: self.bucketURL)
                .subscribe(to: image.imagePath, in: self.CHAT_STORAGE_FOLDER)
                .print("subscribe image in chatService for path: \(image.imagePath)")
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    if let index = message.images?.firstIndex(where: {
                        $0.imagePath == image.imagePath
                    }) {
                        if message.images?.count ?? 0 > index {
                            message.images?[index].image = $0
                            subject.send(message)
                        }
                    }
                })
                .store(in: &imageCancellables)
        }
        
        return subject.eraseToAnyPublisher()
    }
    
}

private var imageCancellables: Set<AnyCancellable> = []


// MARK: - Send
extension FirestoreChatService {
    
    func sendMessage(_ message: Message) async throws -> Message {
        do {
            
            // Upload Message
            try FirestoreChatReferenceFactory.generateMessageReference(by: message.chatID, and: message.id)
                .setData(from: message)
            
            // Upload Images
            if let images = message.images {
                for image in images {
                    if let uiImage = image.image {
                        try await FirebaseStorageService(bucketURL: self.bucketURL).uploadImage(uiImage, fileName: image.imagePath, folder: self.CHAT_STORAGE_FOLDER)
                    }
                }
            }
            
            return message
        } catch {
            print("Error while trying to send message: \(error.localizedDescription)")
            throw FirestoreError.failedSet
        }
    }
    
}
