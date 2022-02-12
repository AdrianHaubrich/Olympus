//
//  MockChatService.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class MockChatService: ChatService {
    
    var type: ChatServiceType = .mock
    
    let currentUserID = "uid_demo_1"
    let currentUserName = "Adrian"
    
    private let chats = [
        Chat(id: "id_chat_1", title: "Title 1", description: "Description 1", ownerID: "uid_demo_1", memberIDs: ["uid_demo_1", "uid_demo_2"]),
        Chat(id: "id_chat_2", title: "Title 2", description: "Description 2", ownerID: "uid_demo_2", memberIDs: ["uid_demo_1", "uid_demo_2"])
    ]
    
    private var chatMessages = [
        Message(text: "Message 1", ownerID: "uid_demo_1", chatID: "id_chat_1"),
        Message(text: "Message 2", ownerID: "uid_demo_2", chatID: "id_chat_1"),
        Message(text: "Message 1", ownerID: "uid_demo_1", chatID: "id_chat_2"),
        Message(text: "Message 2", ownerID: "uid_demo_2", chatID: "id_chat_2")
    ]
    
    private let DEFAULT_CHATS_LIMIT: Int = 5
    private let DEFAULT_MESSAGES_LIMIT: Int = 10
    
}

// MARK: - Fetch
extension MockChatService {
    
    // TODO: Support for lazy fetching...
    
    func fetchNextChats(by id: String,
                        with limit: Int?) async -> [Chat]? {
        var foundChats: [Chat] = []
        for chat in self.chats {
            if chat.memberIDs.contains(id) {
                foundChats.append(chat)
            }
            
            // Limit
            if foundChats.count >= limit ?? self.DEFAULT_CHATS_LIMIT {
                return foundChats
            }
        }
        return chats
    }
    
    func fetchChat(by chatID: String) async -> Chat? {
        for chat in self.chats {
            if chat.id == chatID {
                return chat
            }
        }
        return nil
    }
    
    func fetchNextMessages(for chatID: String,
                           with limit: Int?) async -> [Message]? {
        var foundMessages: [Message] = []
        for message in self.chatMessages {
            if message.chatID == chatID {
                foundMessages.append(message)
            }
            
            // Limit
            if foundMessages.count >= limit ?? self.DEFAULT_MESSAGES_LIMIT {
                return foundMessages
            }
        }
        return foundMessages
    }
    
}

// MARK: - Listen
extension MockChatService {
    
    func subscribe(to chatID: String) -> AnyPublisher<[Message?], Never> {
        return self.chatMessages
            .publisher
            .collect()
            .map {
                return $0.filter { message in
                    return message.chatID == chatID
                }
            }
            .eraseToAnyPublisher()
    }
    
    func subscribeImages(for message: Message) throws -> AnyPublisher<Message, Error> {
        let subject = PassthroughSubject<Message, Error>()
        
        let newMessage = Message(id: message.id, text: message.text, images: [(UIImage(), "nil")], ownerID: message.ownerID, chatID: message.chatID, date: message.date)
        
        subject.send(newMessage)
        
        return subject.eraseToAnyPublisher()
    }
    
}

// MARK: - Send
extension MockChatService {
    
    func sendMessage(_ message: Message) async -> Message {
        self.chatMessages.append(message)
        return message
    }
    
}
