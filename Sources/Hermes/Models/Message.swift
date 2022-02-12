//
//  Message.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Foundation
import SwiftUI
import Prometheus

public struct Message: Identifiable {
    
    public let id: String
    let chatID: String
    let text: String?
    var images: [(image: UIImage?, imagePath: String)]?
    let date: String
    
    let ownerID: String
    
    
    // Init
    init(id: String? = nil,
         text: String? = nil,
         images: [(image: UIImage?, imagePath: String)]? = nil,
         ownerID: String,
         chatID: String,
         date: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.images = images
        self.ownerID = ownerID
        self.chatID = chatID
        self.date = date ?? DateHelper.dbString(from: Date())
    }
    
}

// MARK: - Codable
extension Message: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case imagePathes
        case ownerID
        case chatID
        case date
    }
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Not optional
        self.id = try values.decode(String.self, forKey: .id)
        self.chatID = try values.decode(String.self, forKey: .chatID)
        self.ownerID = try values.decode(String.self, forKey: .ownerID)
        self.date = try values.decode(String.self, forKey: .date)
        
        // Optionals (values that are optional in the **DB**)
        if values.contains(.text) {
            self.text = try values.decode(String.self, forKey: .text)
        } else {
            self.text = nil
        }
        
        if values.contains(.imagePathes) {
            let imagePathes = try values.decode([String].self, forKey: .imagePathes)
            self.images = imagePathes.map { (image: nil, imagePath: $0) }
        } else {
            self.images = nil
        }
        
    }
    
    // MARK: Encodable
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Not optional
        try container.encode(self.id, forKey: .id)
        try container.encode(self.chatID, forKey: .chatID)
        try container.encode(self.ownerID, forKey: .ownerID)
        try container.encode(self.date, forKey: .date)
        
        // Optionals
        if let text = self.text {
            try container.encode(text, forKey: .text)
        }
        
        if let images = self.images {
            let imagePathes = images.map { $0.imagePath }
            try container.encode(imagePathes, forKey: .imagePathes)
        }
        
    }
    
}

// MARK: - Equatable
extension Message: Equatable {
    
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
}
