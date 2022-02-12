//
//  ChatListViewModel.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation
import Prometheus

class ChatListViewModel: ViewModel {
    
    // TODO: Add lazy loading...
    
    @Published var state: ChatListState = ChatListState(chats: [])
    
    // Init
    init(chatService: ChatService) {
        
        Task.detached {
            
            var viewModels: [AnyViewModel<ChatDetailState, ChatDetailInput>] = []
            
            if let chats = await chatService.fetchNextChats(by: chatService.currentUserID, with: 10) {
                for chat in chats {
                    let viewModel = AnyViewModel(ChatDetailViewModel(chat: chat, chatService: chatService))
                    viewModels.append(viewModel)
                }
            }
            
            await self.setState(viewModels: viewModels)
        }
    }
    
    @MainActor
    func setState(viewModels: [AnyViewModel<ChatDetailState, ChatDetailInput>]) {
        self.state = ChatListState(chats: viewModels)
    }
    
}


// MARK: - Trigger
extension ChatListViewModel {
    
    func trigger(_ input: Never) {}
    
}
