//
//  AuthService.swift
//  Charon
//
//  Created by Adrian Haubrich on 29.11.21.
//

import Foundation

public protocol AuthService {
    
    // MARK: Create Account
    func createAccount(with email: String, password: String) async throws
    
    // MARK: Login
    func signIn(with email: String,
                password: String) async throws
    
    func signInWithApple(idToken: String,
                         rawNonce: String,
                         state: SignInType) async throws
    
    // MARK: Logout
    func logout() async throws
    
}
