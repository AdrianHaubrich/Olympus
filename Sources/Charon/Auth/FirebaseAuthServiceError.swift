//
//  FirebaseAuthServiceError.swift
//  Charon
//
//  Created by Adrian Haubrich on 29.11.21.
//

import Foundation

enum FirebaseAuthServiceError: String, Error {
    case accountCreationEmailFailed = "Accout creation with email failed."
    case loginFailed = "Login failed."
    case loginWithCredentialFailed = "Login with credential failed."
    case logoutFailed = "Logout failed."
    
    case unableToGetUID = "Unable to get uid."
}
