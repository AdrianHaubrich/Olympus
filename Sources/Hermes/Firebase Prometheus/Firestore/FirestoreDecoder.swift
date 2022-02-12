//
//  File.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Firebase

struct FirestoreDecoder {
    static func decode<T>(_ type: T.Type) -> (DocumentSnapshot) -> T? where T: Decodable {
        { snapshot in
            try? snapshot.data(as: type)
        }
    }
}
