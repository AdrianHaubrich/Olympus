//
//  FirebaseAuthService.swift
//  Charon
//
//  Created by Adrian Haubrich on 29.11.21.
//

import Foundation
import Firebase
import FirebaseAuth
import Prometheus

public class FirebaseAuthService: AuthService {
    
    let mockDataIdKey = "mockDataUIDKeys"
    let mockDataEmailKeyPrefix = "_mockDataEmail"
    let mockDataPasswordKeyPrefix = "_mockDataPassword"
    
    public init() {}
    
}


// MARK: - Create Account
extension FirebaseAuthService {
    
    @discardableResult
    public func createAccount(with email: String, password: String) async throws -> String? {
        
        // Auth
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirebaseAuthServiceError.accountCreationEmailFailed
        }
        
        // Get uid from Firebase
        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseAuthServiceError.unableToGetUID
        }
        
        // Save Auth
        do {
            try await FirestoreAuthSaveService(uid: uid).saveAuth(.email, step: AuthLoginStep(.SIGNED_IN_FIRST_TIME))
        } catch {
            try await self.logout()
            throw error
        }
        
        return uid
    }
    
}


// MARK: - Login
extension FirebaseAuthService {
    
    public func signIn(with email: String, password: String) async throws {
        
        // Auth
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirebaseAuthServiceError.loginFailed
        }
        
        // Get uid from Firebase
        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseAuthServiceError.unableToGetUID
        }
        
        // Save Auth
        do {
            try await FirestoreAuthSaveService(uid: uid).saveAuth(.email, step: AuthLoginStep(.SIGNED_IN))
        } catch {
            try await self.logout()
            throw error
        }
        
    }
    
    public func signInWithApple(idToken: String, rawNonce: String, state: SignInType) async throws {
        
        // Credential - get oauth-credential from Firebase
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: rawNonce)
        
        // Use credential for firebase login
        do {
            _ = try await Auth.auth().signIn(with: credential)
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirebaseAuthServiceError.loginWithCredentialFailed
        }
        
        // Get uid from Firebase
        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseAuthServiceError.unableToGetUID
        }
        
        // Save Auth
        do {
            let saveService = FirestoreAuthSaveService(uid: uid)
            
            switch state {
                case .signIn:
                    try await saveService.saveAuth(.apple, step: AuthLoginStep(.SIGNED_IN_FIRST_TIME))
                case .link, .reauth:
                    try await saveService.saveAuth(.apple, step: AuthLoginStep(.SIGNED_IN))
            }
        } catch {
            try await self.logout()
            throw error
        }
        
    }
    
}


// MARK: - Logout
extension FirebaseAuthService {
    
    public func logout() async throws {
        
        // Get uid from Firebase
        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirebaseAuthServiceError.unableToGetUID
        }
        
        // Save
        try await FirestoreAuthSaveService(uid: uid).saveAuth(.email, step: AuthLoginStep(.SIGNED_OUT))
        
        // Logout
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirebaseAuthServiceError.logoutFailed
        }
        
    }
    
}


// MARK: - Mock
extension FirebaseAuthService {
    
    /// Generate a random string.
    ///
    /// Can be used to generate unsecure passwords. Only use for mock-data.
    ///
    /// - Parameter length: The length of the string. Needs to be 5 of higher.
    /// - Returns: The generated string.
    private func generateRandomMockString(length: Int) -> String {
        if length >= 5 {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var string = String((0..<length-4).map{ _ in letters.randomElement()! })
            string += "Aa!1" // Append to fulfill necessary password-rules
            return string
        }
        return ""
    }
    
    @discardableResult
    public func setUpMockAccount() async throws -> (uid: String, email: String, password: String)? {
        
        let mockEmail = "\(generateRandomMockString(length: 12).lowercased())@olympus-firebase.com"
        let mockPassword = generateRandomMockString(length: 24)
        
        do {
            
            // Create Account
            let uid = try await self.createAccount(with: mockEmail, password: mockEmail)
            
            guard let uid = uid else {
                throw FirebaseAuthServiceError.accountCreationEmailFailed
            }
            
            // Safe login-data
            UserDefaultsService.add(uid, to: self.mockDataIdKey)
            UserDefaultsService.set(mockEmail, with: uid + self.mockDataEmailKeyPrefix)
            UserDefaultsService.set(mockPassword, with: uid + self.mockDataPasswordKeyPrefix)
            
            return (uid, mockEmail, mockPassword)
            
        } catch {
            throw error
        }
        
    }
    
    public func signInMockAccount(uid: String? = nil) async throws {
        
        // Get uid
        let uid = try? unwrapUID(uid: uid)
        
        guard let uid = uid else {
            throw FirebaseAuthServiceError.unableToUnwrapUID
        }
        
        // Get mail & password
        let mail = UserDefaults.standard.string(forKey: uid + self.mockDataEmailKeyPrefix)?.lowercased()
        let password = UserDefaults.standard.string(forKey: uid + self.mockDataPasswordKeyPrefix)
        
        guard let mail = mail, let password = password else {
            throw FirebaseAuthServiceError.loginMockFailed
        }
        
        try? await self.signIn(with: mail, password: password)
    }
    
    private func unwrapUID(uid: String?) throws -> String {
        if let uid = uid {
            return uid
        } else {
            let uid = try? UserDefaultsService.getStringArray(by: self.mockDataIdKey).first
            
            guard let uid = uid else {
                throw FirebaseAuthServiceError.unableToUnwrapUID
            }
            
            return uid
        }
    }

    
}
