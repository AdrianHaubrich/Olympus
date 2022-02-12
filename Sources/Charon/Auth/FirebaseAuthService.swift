//
//  FirebaseAuthService.swift
//  Charon
//
//  Created by Adrian Haubrich on 29.11.21.
//

import Foundation
import Firebase
import FirebaseAuth

public class FirebaseAuthService: AuthService {}


// MARK: - Create Account
extension FirebaseAuthService {
    
    public func createAccount(with email: String, password: String) async throws {
        
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
