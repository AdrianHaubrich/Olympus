//
//  LoginStep.swift
//  Charon
//
//  Created by Adrian Haubrich on 03.12.21.
//

import Foundation

public protocol LoginStep {
    var step: String { get }
}

public class AuthLoginStep: LoginStep {
    
    public var step: String
    
    public init(_ step: String) {
        self.step = step
    }
    
    public init(_ stepType: AuthLoginStepType) {
        self.step = stepType.rawValue
    }
    
}

public enum AuthLoginStepType: String {
    case SIGNED_IN_FIRST_TIME = "SIGNED_IN_FIRST_TIME"
    case SIGNED_IN = "SIGNED_IN"
    case SIGNED_OUT = "SIGNED_OUT"
}
