//
//  AuthSaveService.swift
//  Charon
//
//  Created by Adrian Haubrich on 03.12.21.
//

import Foundation

protocol AuthSaveService {
    
    var uid: String { get }
    
    func saveAuth(_ method: LoginMethod, step: LoginStep) async throws
    func updateStep(_ step: LoginStep) async throws
    func loadAuth() async throws -> (LoginMethod, LoginStep)
    
}
