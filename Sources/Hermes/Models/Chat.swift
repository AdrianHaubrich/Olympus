//
//  Chat.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Foundation

public struct Chat: Identifiable {
    
    public let id: String
    let title: String?
    let description: String?
    
    let messages: [Message]
    
    let ownerID: String
    let memberIDs: [String]
    
    // Init
    public init(id: String? = nil,
         title: String? = nil,
         description: String? = nil,
         messages: [Message]? = nil,
         ownerID: String,
         memberIDs: [String]? = nil) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.description = description
        self.messages = messages ?? []
        self.ownerID = ownerID
        self.memberIDs = memberIDs ?? []
    }
    
    // Codable (with optionals)
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Not optional
        self.id = try values.decode(String.self, forKey: .id)
        self.ownerID = try values.decode(String.self, forKey: .ownerID)
        self.memberIDs = try values.decode([String].self, forKey: .memberIDs)
        
        // Optionals (values that are optional in the **DB**)
        if values.contains(.title) {
            self.title = try values.decode(String.self, forKey: .title)
        } else {
            self.title = nil
        }
        
        if values.contains(.description) {
            self.description = try values.decode(String.self, forKey: .description)
        } else {
            self.description = nil
        }
        
        if values.contains(.messages) {
            self.messages = try values.decode([Message].self, forKey: .messages)
        } else {
            self.messages = []
        }
        
    }
    
}

// MARK: - Codable
extension Chat: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case messages
        case ownerID
        case memberIDs
    }
    
}
