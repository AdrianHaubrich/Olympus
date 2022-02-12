//
//  ChatDetailView.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import SwiftUI
import Helena
import Prometheus
import Photos
import PhotosUI

public struct ChatDetailView: View {
    
    // View Model
    @ObservedObject var viewModel: AnyViewModel<ChatDetailState, ChatDetailInput>
    
    // State
    @State private var isImagePickerPresented = false
    @State private var selectionLimit = 1
    @State private var newMessage = ""
    @State private var pickerResult: [UIImage] = []
    
    // Body
    public var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.chat.messages) { message in
                    LazyVStack {
                        ChatMessageElement(senderName: message.ownerID, text: message.text, isUserOwner: message.ownerID == viewModel.currentUserID, uiImages: self.generateImagesForMessage(message: message))
                            .rotationEffect(.radians(.pi))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                            .onAppear {
                                self.fetchImage(for: message)
                                self.fetchNewMessagesLazily(currentMessage: message)
                            }
                    }
                }
                .padding(.horizontal)
                .onTapGesture { self.endEditing(force: true) }
            }
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
            
            Divider()
            
            HStack {
                HelenaChatTextField($newMessage, imageSelected: self.pickerResult.count == 0 ? false : true, imageLimit: 4) {
                    sendMessage()
                } onImageSelection: { image in
                    self.pickerResult.append(image)
                }

                // TODO: Remove after verifying that the code above works as expected #id_image_picker-chat_detail_view
                /* Deprecated
                 HelenaChatTextField($newMessage, imageSelected: self.pickerResult.count == 0 ? false : true, sendAction: {
                    sendMessage()
                }, imagePickerAction: {
                    self.isImagePickerPresented.toggle()
                })*/
                
            }
            .padding([.leading, .top, .trailing])
        }
        // TODO: Remove after verifying that the code above works as expected #id_image_picker-chat_detail_view
        /*.sheet(isPresented: self.$isImagePickerPresented) {
            HelenaPHPicker(configuration: self.generatePhotoConfig(), pickerResult: self.$pickerResult, isPresented: $isImagePickerPresented)
        }*/
        .navigationBarTitle(Text(viewModel.chat.title ?? "Unknown"), displayMode: .inline)
        .onAppear {
            self.fetchFirstMessages()
            self.startListeningForNewMessages()
        }
        .onDisappear {
            self.stopListeningForNewMessages()
        }
    }
}

extension ChatDetailView {
    
    // TODO: Remove after verifying that the code above works as expected #id_image_picker-chat_detail_view
    /*func generatePhotoConfig() -> PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 4
        return config
    }*/
    
    private func generateImagesForMessage(message: Message) -> [UIImage] {
        var result: [UIImage] = []
        if let images = message.images {
            for image in images {
                if let image = image.image {
                    result.append(image)
                }
            }
        }
        return result
    }
    
}

extension ChatDetailView {
    
    private func fetchFirstMessages() {
        viewModel.trigger(.fetchMessages)
    }
    
    private func startListeningForNewMessages() {
        viewModel.trigger(.startListeningToNewMessages)
    }
    
    private func stopListeningForNewMessages() {
        viewModel.trigger(.stopListeningToNewMessages)
    }
    
    private func sendMessage() {
        viewModel.trigger(.addMessage(newMessage, self.pickerResult))
        self.newMessage = ""
        self.pickerResult = []
    }
    
    private func fetchNewMessagesLazily(currentMessage: Message) {
        viewModel.trigger(.fetchLazily(currentMessage: currentMessage))
    }
    
    private func fetchImage(for message: Message) {
        viewModel.trigger(.fetchImages(forMessage: message))
    }
    
    // TODO: Prometheus
    private func endEditing(force: Bool) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
}



// MARK: - Preview
/*struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView(viewModel: <#AnyViewModel<ChatDetailState, ChatDetailInput>#>)
    }
}*/
