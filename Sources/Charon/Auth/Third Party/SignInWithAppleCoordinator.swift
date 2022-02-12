//
//  SignInWithAppleCoordinator.swift
//  Charon
//
//  Created by Adrian Haubrich on 30.11.21.
//

import Foundation
import AuthenticationServices
import CryptoKit

class SignInWithAppleCoordinator: NSObject {
    
    // Window
    private weak var window: UIWindow!
    
    // Unhashed nonce
    fileprivate var currentNonce: String?
    
    // Sign In Callback
    private var onSignedIn: ((Bool) -> Void)?
    
    // Services
    private let authService: AuthService
    
    // Init
    init(window: UIWindow?, authService: AuthService) {
        self.window = window
        self.authService = authService
    }
    
}


// MARK: - Sign In
extension SignInWithAppleCoordinator {
    
    private func appleIDRequest(withState: SignInType) -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        request.state = withState.rawValue
        
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        return request
    }
    
    /// Link an existing account to Apple.
    func link(onSignedIn: @escaping (Bool) -> Void) {
        self.onSignedIn = onSignedIn
        
        let request = appleIDRequest(withState: .link)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func signIn(onSignedIn: @escaping (Bool) -> Void) {
        self.onSignedIn = onSignedIn
        
        let request = appleIDRequest(withState: .signIn)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func reauth(onSignedIn: @escaping (Bool) -> Void) {
        self.onSignedIn = onSignedIn
        
        let request = appleIDRequest(withState: .reauth)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}


// MARK: - ASAuthorization
extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {
    
    // MARK: Did complete Authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                return
            }
            guard let stateRaw = appleIDCredential.state, let state = SignInType(rawValue: stateRaw) else {
                print("Invalid state: request must be started with one of the SignInStates")
                return
            }
            
            // Link with authService
            Task.detached {
                do {
                    try await self.authService.signInWithApple(idToken: idTokenString, rawNonce: nonce, state: state)
                } catch {
                    
                }
            }
            
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Login with Apple failed!")
    }
    
}


// MARK: - Anchor
extension SignInWithAppleCoordinator: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
}


// MARK: - Nonce
extension SignInWithAppleCoordinator {
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}
