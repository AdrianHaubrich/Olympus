//
//  FirestoreError.swift
//  
//
//  Created by Adrian Haubrich on 18.11.21.
//

import Foundation

public enum FirestoreError: String, Error {
    case failedFetch = "Failed to fetch data from Firestore."
    case failedListener = "Failed to listen to data in Firestore."
    case failedSet = "Failed to set data in Firestore."
}
