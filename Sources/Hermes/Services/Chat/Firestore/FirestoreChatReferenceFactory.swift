//
//  FirestoreChatReferenceFactory.swift
//  
//
//  Created by Adrian Haubrich on 21.10.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Prometheus

struct FirestoreChatReferenceFactory {
    
    // Constants
    static let PATH_TO_CHATS = "chats"
    static let PATH_TO_MESSAGES = "messages"
    
}

// MARK: - Fetch
extension FirestoreChatReferenceFactory {
    
    // MARK: Chat
    static func generateChatReference(by chatID: String) -> DocumentReference {
        return Firestore.firestore()
            .collection(self.PATH_TO_CHATS)
            .document(chatID)
    }
    
    static func generateChatsQuery(by uid: String,
                                   with limit: Int?,
                                   start atDocument: DocumentSnapshot? = nil) -> Query {
        var query = Firestore.firestore()
            .collection(self.PATH_TO_CHATS)
            .whereField("memberIDs", arrayContains: uid)
        
        if let limit = limit {
            query = query
                .limit(to: limit)
        }
        
        if let atDocument = atDocument {
            query = query
                .start(atDocument: atDocument)
        }
        
        return query
    }
    
    
    // MARK: Message
    static func generateMessageReference(by chatID: String,
                                         and messageID: String? = nil) -> DocumentReference {
        
        let colRef = Firestore.firestore()
            .collection(FirestoreChatReferenceFactory.PATH_TO_CHATS)
            .document(chatID)
            .collection(FirestoreChatReferenceFactory.PATH_TO_MESSAGES)
        
        let docRef: DocumentReference
        
        if let messageID = messageID {
            docRef = colRef
                .document(messageID)
        } else {
            docRef = colRef
                .document()
        }
        
        return docRef
    }
    
    static func generateMessagesQuery(for chatID: String,
                                      with limit: Int? = nil,
                                      descending: Bool? = nil,
                                      inFuture: Bool? = nil,
                                      start atDocument: DocumentSnapshot? = nil) -> Query {
        
        var query = Firestore.firestore()
            .collection(self.PATH_TO_CHATS)
            .document(chatID)
            .collection(self.PATH_TO_MESSAGES)
            .order(by: "date", descending: descending ?? true)
        
        if let limit = limit {
            query = query
                .limit(to: limit)
        }
        
        if let inFuture = inFuture {
            if inFuture {
                let now = DateHelper.dbString(from: Date())
                query = query
                    .whereField("date", isGreaterThanOrEqualTo: now)
            }
        }
        
        if let atDocument = atDocument {
            query = query
                .start(atDocument: atDocument)
        }
        
        return query
    }
    
}
