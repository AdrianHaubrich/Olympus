//
//  FirestoreDecoder.swift
//  
//
//  Created by Adrian Haubrich on 18.11.21.
//

import Firebase

public struct FirestoreDecoder {
    public static func decode<T>(_ type: T.Type) -> (DocumentSnapshot) -> T? where T: Decodable {
        { snapshot in
            try? snapshot.data(as: type)
        }
    }
}
