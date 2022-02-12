//
//  FirestoreAuthSaveService.swift
//  Charon
//
//  Created by Adrian Haubrich on 03.12.21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

public class FirestoreAuthSaveService: AuthSaveService {
    
    let db = Firestore.firestore()
    let ref: DocumentReference
    let uid: String
    
    
    public init(uid: String) {
        self.uid = uid
        self.ref = db.collection("charon").document(uid)
    }
    
}


// MARK: - Save & Update
extension FirestoreAuthSaveService {
    
    public func saveAuth(_ method: LoginMethod, step: LoginStep) async throws {
        let data = [
            "ownerID" : uid,
            "method" : method.rawValue,
            "step" : step.step
        ] as [String : Any]
        
        do {
            try await ref.setData(data)
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirestoreAuthSaveServiceError.unableToUploadAuth
        }
    }
    
    public func updateStep(_ step: LoginStep) async throws {
        let data = [
            "step" : step.step
        ] as [String : Any]
        
        do {
            try await ref.updateData(data)
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirestoreAuthSaveServiceError.unableToUpdateAuthStep
        }
    }
    
}


// MARK: - Load
extension FirestoreAuthSaveService {
    
    public func loadAuth() async throws -> (LoginMethod, LoginStep) {
        do {
            
            let doc = try await ref.getDocument()
            
            // Data
            guard let data = doc.data() else {
                throw FirestoreAuthSaveServiceError.documentIsEmpty
            }
            
            // Method
            guard let methodRaw = data["method"] as? String else {
                throw FirestoreAuthSaveServiceError.documentDoesNotContainMethod
            }
            
            guard let method = LoginMethod(rawValue: methodRaw) else {
                throw FirestoreAuthSaveServiceError.invalidMethod
            }
            
            // Step
            guard let stepString = data["step"] as? String else {
                throw FirestoreAuthSaveServiceError.documentDoesNotContainStep
            }
            let step = AuthLoginStep(stepString)
            
            return (method, step)
            
        } catch {
            print("Error in \(#file) in \(#function): " + error.localizedDescription)
            throw FirestoreAuthSaveServiceError.unableToLoadAuth
        }
    }
    
}
