//
//  File.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Combine

public protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    
    associatedtype State
    associatedtype Input
    
    var state: State { get }
    
    func trigger(_ input: Input)

}
