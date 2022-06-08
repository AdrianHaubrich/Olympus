//
//  HelenaChatMessage.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

#if os(macOS)
import MacOSCompatibility
#else
import UIKit
#endif

public protocol HelenaChatMessage {
    
    var text: String? { get set }
    var images: [(image: UIImage?, imagePath: String)]? { get set }
    var date: String { get set }
    
    func isUserOwner() -> Bool
    func getUserName() async throws -> String
    
}
