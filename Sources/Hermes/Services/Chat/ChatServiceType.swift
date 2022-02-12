//
//  ChatServiceType.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation

public enum ChatServiceType: Equatable {
    case mock
    case firestore(uid: String, username: String, bucketURL: String)
}
