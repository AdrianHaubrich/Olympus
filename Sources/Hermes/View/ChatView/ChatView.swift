//
//  ChatView.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import SwiftUI
import Prometheus

public struct ChatView: View {
    
    // View Model
    @StateObject var viewModel: AnyViewModel<ChatListState, Never>
    
    // Init
    public init(_ chatServiceType: ChatServiceType) {
        
        let chatService: ChatService
        
        switch(chatServiceType) {
            case .mock:
                chatService = MockChatService()
            case .firestore(let uid, let username, let bucketURL):
                chatService = FirestoreChatService(currentUserID: uid, currentUserName: username, bucketURL: bucketURL)
        }
        
        self._viewModel = StateObject(wrappedValue: AnyViewModel(ChatListViewModel(chatService: chatService)))
    }
    
    // Body
    public var body: some View {
        ChatListView(viewModel: self.viewModel)
    }
}


// MARK: - Preview
public struct ChatView_Previews: PreviewProvider {
    public static var previews: some View {
        ChatView(.mock)
    }
}
