//
//  ChatDetailState.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Combine

struct ChatDetailState {
    
    var chat: Chat
    var currentUserID: String?
    
}

// MARK: Identifiable
extension ChatDetailState: Identifiable {
    var id: Chat.ID {
        return chat.id
    }
}

