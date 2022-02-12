//
//  File.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation
import SwiftUI

enum ChatDetailInput {
    case fetchMessages
    case startListeningToNewMessages
    case stopListeningToNewMessages
    case fetchLazily(currentMessage: Message)
    case addMessage(String, [UIImage]?)
    case fetchImages(forMessage: Message)
}
