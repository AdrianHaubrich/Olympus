//
//  AuthService.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Foundation
import Firebase
import FirebaseAuth

public class AuthService {
    
    @discardableResult
    public static func login() async -> AuthDataResult? {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: "testUser_1@mail.com", password: "tu_1_password937682482")
            return authResult
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
