//
//  UserDefaultsService.swift
//  
//
//  Created by Adrian Haubrich on 24.10.21.
//

import Foundation

public struct UserDefaultsService {}

extension UserDefaultsService {
    
    /// Saves the given value to UserDefaults with the given key.
    /// - WARNING: Overrides all already saved value(s) associated with this key.
    /// - Parameters:
    ///   - value: The value that should be saved.
    ///   - key: The key where the value should be saved.
    @discardableResult
    public static func set(_ value: Any, with key: String) -> Any {
        UserDefaults.standard.setValue(value, forKey: key)
        return value
    }
    
    @discardableResult
    static func set(_ value: Any, with key: UserDefaultsKey) -> Any {
        set(value, with: key.rawValue)
    }
    
    
    static func remove(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    static func remove(for key: UserDefaultsKey) {
        remove(for: key.rawValue)
    }
    
}

// MARK: - Arrays
extension UserDefaultsService {
    
    /// Tries to load a String-Array from UserDefaults with a given key.
    /// - Parameter key: KeyType that should be used to load the data.
    /// - Returns: The associated String-Array saved in UserDefaults.
    public static func getStringArray(by key: String) throws -> [String] {
        guard let values = UserDefaults.standard.stringArray(forKey: key) else {
            throw UserDefaultsError.failedToGetStringArray
        }
        
        return values
    }
    
    static func getStringArray(by key: UserDefaultsKey) throws -> [String] {
        try getStringArray(by: key.rawValue)
    }
    
    /// Saves the given value to an array using the given key.
    ///
    /// This function appends the value instead of overwritting the saved data.
    ///
    /// - Parameters:
    ///   - value: The value that should be saved.
    ///   - key: The key where the value should be saved.
    ///   - key: The key where the value should be saved.
    @discardableResult
    public static func add(_ value: String, to key: String) -> [String] {
        do {
            var array = try getStringArray(by: key)
            array.append(value)
            set(array, with: key)
            return array
        } catch {
            set([value], with: key)
            return [value]
        }
    }
    
    @discardableResult
    static func add(_ value: String, to key: UserDefaultsKey) -> [String] {
        add(value, to: key.rawValue)
    }
    
    /// Removes a specific value from the key.
    ///
    /// In order to work properly, the key has to reference a persistent String-Array.
    ///
    /// - Parameters:
    ///   - value: The String-Value that should be removed from the persistent String-Array.
    ///   - key: The key where the value should be removed from.
    @discardableResult
    public static func remove(_ value: String, with key: String) throws -> [String] {
        var array = try getStringArray(by: key)
        if let index = array.firstIndex(of: value) {
            array.remove(at: index)
        }
        set(array, with: key)
        return array
    }
    
    @discardableResult
    static func remove(_ value: String, with key: UserDefaultsKey) throws -> [String] {
        try remove(value, with: key.rawValue)
    }
    
    /// Clears all values saved in UserDefaults under the given key.
    /// - Parameter key: The key where the values should be cleared.
    /// - Returns: The cleared value.
    @discardableResult
    static func clear(_ key: String) throws -> Any {
        guard let value = UserDefaults.standard.value(forKey: key) else {
            throw UserDefaultsError.keyIsInvalid
        }
        UserDefaults.standard.setValue(nil, forKey: key)
        return value
    }
    
    @discardableResult
    static func clear(_ key: UserDefaultsKey) throws -> Any {
        try clear(key.rawValue)
    }
    
}
