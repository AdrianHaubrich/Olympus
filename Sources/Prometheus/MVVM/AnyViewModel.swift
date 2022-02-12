//
//  AnyViewModel.swift
//  
//
//  Created by Adrian Haubrich on 19.10.21.
//

import Foundation
import Combine

@dynamicMemberLookup
public final class AnyViewModel<State, Input>: ViewModel {
    
    // MARK: Stored properties
    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void
    
    // MARK: Computed properties
    public var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }
    
    public var state: State {
        wrappedState()
    }
    
    // MARK: Methods
    public func trigger(_ input: Input) {
        wrappedTrigger(input)
    }
    
    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }
    
    // MARK: Initialization
    public init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        self.wrappedState = { viewModel.state }
        self.wrappedTrigger = viewModel.trigger
    }
    
}

extension AnyViewModel: Identifiable where State: Identifiable {
    public var id: State.ID {
        state.id
    }
}
