//
//  AuthService.swift
//  Charon
//
//  Created by Adrian Haubrich on 29.11.21.
//

import Foundation

public protocol AuthService {
    
    // MARK: Create Account
    /// Create a new account.
    ///
    /// - Parameters:
    ///   - email: The email-adress associated with the account.
    ///   - password: The password associated with the account.
    ///
    /// - Returns: The uid of the created user.
    @discardableResult
    func createAccount(with email: String, password: String) async throws -> String?
    
    
    // MARK: Login
    /// Sign in to an existing account.
    ///
    /// - Parameters:
    ///   - email: The email-adress associated with the account.
    ///   - password: The password associated with the account.
    func signIn(with email: String,
                password: String) async throws
    
    /// Support for signInWithApple.
    func signInWithApple(idToken: String,
                         rawNonce: String,
                         state: SignInType) async throws
    
    // MARK: Logout
    func logout() async throws
    
    // MARK: Delete
    // func deleteAccount() async throws
    
    
    // MARK: - Mock
    /// Create a new mock account with a random username and password
    ///
    /// The uid, username and password is saved in user defaults (on the device) to enable a password-less login flow.
    ///
    ///  - warning: Only use for MOCK accounts! Never use it to create a productive, real or privileged user.
    ///
    /// - Returns: The login data of the created mock user: uid, username, password
    @discardableResult
    func setUpMockAccount() async throws -> (uid: String, email: String, password: String)?
    
    /// Login to an existing mock account
    ///
    /// - Parameter uid: The uid of the mock account that should be logged in. Leave it blank to auto-select the oldes
    func signInMockAccount(uid: String?) async throws
    
    
    // func logoutMockAccount() async throws
    // func deleteMockAccount() async throws
    // func resetMockAccount() async throws
    
}
