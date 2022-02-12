//
//  UserDefaultsError.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation

enum UserDefaultsError: String, Error {
    case failedToGetStringArray = "Failed to get string-array."
    case keyIsInvalid = "Key is invalid."
}
