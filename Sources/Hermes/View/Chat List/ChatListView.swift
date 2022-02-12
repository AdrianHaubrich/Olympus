//
//  ChatListView.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import SwiftUI
import Prometheus

public struct ChatListView: View {
    
    // View Model
    @ObservedObject var viewModel: AnyViewModel<ChatListState, Never>
    
    // Body
    public var body: some View {
        
        NavigationView {
            ScrollView {
                ForEach(viewModel.chats) { chatViewModel in
                    LazyVStack {
                        NavigationLink(destination: ChatDetailView(viewModel: chatViewModel)) {
                            ChatListElement(title: chatViewModel.chat.title ?? "Unknown", description: chatViewModel.chat.description)
                        }.buttonStyle(.plain)
                    }
                }.padding(.horizontal)
            }.navigationTitle("Chats")
        }
        
    }
    
}
