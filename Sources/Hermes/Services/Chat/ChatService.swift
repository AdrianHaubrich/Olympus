//
//  File.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ChatService {
    
    var type: ChatServiceType { get }
    
    // MARK: User
    var currentUserID: String { get }
    var currentUserName: String { get }
    
    // MARK: Fetch
    func fetchChat(by chatID: String) async -> Chat?
    func fetchNextChats(by uid: String, with limit: Int?) async -> [Chat]?
    func fetchNextMessages(for chatID: String, with limit: Int?) async -> [Message]?
    
    // MARK: Listen
    func subscribe(to chatID: String) -> AnyPublisher<[Message?], Never>
    func subscribeImages(for message: Message) throws -> AnyPublisher<Message, Error>
    
    // MARK: Send
    @discardableResult
    func sendMessage(_ message: Message) async throws -> Message
    
}
