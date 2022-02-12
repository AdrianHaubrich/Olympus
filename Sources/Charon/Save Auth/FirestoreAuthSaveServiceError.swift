//
//  FirestoreAuthSaveServiceError.swift
//  Charon
//
//  Created by Adrian Haubrich on 03.12.21.
//

import Foundation

enum FirestoreAuthSaveServiceError: String, Error {
    case unableToUploadAuth = "Unable to upload auth."
    case unableToUpdateAuthStep = "Unable to update auth step."
    case unableToLoadAuth = "Unable to load auth."
    
    case documentIsEmpty = "The Auth-Doc saved in Firestore does not contain any data."
    case documentDoesNotContainMethod = "The Auth-Doc saved in Firestore does not contain the login method."
    case documentDoesNotContainStep = "The Auth-Doc saved in Firestore does not contain a login step."
    
    case invalidMethod = "The auth-method found in the data is invalid."
}
