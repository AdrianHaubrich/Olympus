//
//  FirestoreError.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation

enum FirestoreError: String, Error {
    case failedFetch = "Failed to fetch data from Firestore."
    case failedListener = "Failed to listen to data in Firestore."
    case failedSet = "Failed to set data in Firestore."
}
