//
//  ChatListState.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Combine
import Prometheus

struct ChatListState {
    
    var chats: [AnyViewModel<ChatDetailState, ChatDetailInput>]
    
}
