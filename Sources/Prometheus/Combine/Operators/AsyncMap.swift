//
//  AsyncMap.swift
//  
//
//  Created by Adrian Haubrich on 22.10.21.
//

import Combine

extension Publisher {
    public func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}
