//
//  ChatDetailViewModel.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation
import Combine
import Prometheus
import UIKit

class ChatDetailViewModel: ViewModel {
    
    // State
    @Published private(set) var state: ChatDetailState
    private let chatService: ChatService
    private var chat: Chat
    
    // Cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // Init
    init(chat: Chat, chatService: ChatService) {
        self.chat = chat
        self.chatService = chatService
        
        self.state = ChatDetailState(chat: chat, currentUserID: chatService.currentUserID)
    }
    
}

// MARK: - Fetch
extension ChatDetailViewModel {
    
    private func fetchMessages() {
        Task.detached {
            if let messages = await self.chatService.fetchNextMessages(for: self.chat.id, with: 5) {
                let newChat = self.reduceMessages(chat: self.chat, changedMessages: messages)
                DispatchQueue.main.async {
                    self.chat = newChat
                    self.state = ChatDetailState(chat: newChat, currentUserID: self.chatService.currentUserID)
                }
            }
        }
    }
    
    private func listenToNewMessages() {
        self.chatService.subscribe(to: self.chat.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { optionalMessages in
                let messages = optionalMessages.compactMap { $0 }
                let newChat = self.reduceMessages(chat: self.chat, changedMessages: messages)
                DispatchQueue.main.async {
                    self.chat = newChat
                    self.state = ChatDetailState(chat: newChat, currentUserID: self.chatService.currentUserID)
                }
            })
            .store(in: &cancellables)
        
        print("Started listening...")
    }
    
    private func stopListeningToNewMessages() {
        FirestoreSubscription.cancel(id: self.chat.id, isQuery: true)
        
        for cancellable in self.cancellables {
            cancellable.cancel()
        }
        
        print("Canceled listening...")
    }
    
    private func fetchImage(for message: Message) {
        do {
            try chatService
                .subscribeImages(for: message)
                .sink { _ in } receiveValue: { message in
                    let newChat = self.reduceMessages(chat: self.chat, changedMessages: [message])
                    DispatchQueue.main.async {
                        self.chat = newChat
                        self.state = ChatDetailState(chat: newChat, currentUserID: self.chatService.currentUserID)
                    }
                }
                .store(in: &cancellables)
            
        } catch {}

    }
    
    private func reduceMessages(chat: Chat, changedMessages: [Message]) -> Chat {
        
        // Only keep messages that are not included in changed messages
        var oldMessages: [Message] = []
        for oldMessage in chat.messages {
            if changedMessages.firstIndex(where: { $0.id == oldMessage.id }) != nil {} else {
                oldMessages.append(oldMessage)
            }
        }
        
        // Merge arrays
        var allMessages: [Message] = []
        allMessages.append(contentsOf: oldMessages)
        allMessages.append(contentsOf: changedMessages)
        allMessages.sort { $0.date > $1.date }
        
        return Chat(id: chat.id, title: chat.title, description: chat.description, messages: allMessages, ownerID: chat.ownerID, memberIDs: chat.memberIDs)
    }
    
}

// MARK: - Trigger
extension ChatDetailViewModel {
    
    func trigger(_ input: ChatDetailInput) {
        Task.detached {
            switch input {
                case .addMessage(let text, let uiImages):
                    
                    // Images
                    var images: [(image: UIImage?, imagePath: String)]? = nil
                    if let uiImages = uiImages {
                        images = uiImages.map { ($0, UUID().uuidString) }
                    }
                    
                    let message = Message(text: text, images: images, ownerID: self.chatService.currentUserID, chatID: self.chat.id)
                    try await self.chatService.sendMessage(message)
                    
                    // Mock Support
                    if self.chatService.type == ChatServiceType.mock {
                        self.fetchMessages()
                    }
                    
                case .fetchLazily(currentMessage: let currentMessage):
                    // Is current message == last message?
                    if currentMessage == self.chat.messages.last {
                        self.fetchMessages()
                    }
                    
                case .fetchMessages:
                    self.fetchMessages()
                    
                case .startListeningToNewMessages:
                    self.listenToNewMessages()
                    
                case .stopListeningToNewMessages:
                    self.stopListeningToNewMessages()
                    
                case .fetchImages(forMessage: let forMessage):
                    if self.isImageMissing(in: forMessage) {
                        self.fetchImage(for: forMessage)
                    }
            }
        }
    }
    
    private func isImageMissing(in message: Message) -> Bool {
        if let images = message.images {
            for image in images {
                if image.image == nil {
                    return true
                }
            }
        }
        return false
    }
    
}
