//
//  KeyValueDictionaryInKeychain.swift
//
//  Created by Alfred Gao on 2017/1/4.
//
//

import KeychainAccess

public class KeyValueDictionaryInKeychain: NSObject, KeyValueData {

    public let key: String
    public let accessGroup: String
    private let keychain: Keychain
    
    /// Keychain 中的数据每次写强制存储
    ///
    /// Force write to keychain directly
    public var impontanceLevel: Int = 1
    
    var value: [String: Any] = [:]
    
    public var keys: [String] {
        if accessGroup != "" {
            value = NSKeyedUnarchiver.unarchiveObject(with: keychain[data: key]!) as! [String: Any]
        }
        return value.map{(key, value) -> String in return key}
    }
    
    public var count: Int {
        if accessGroup != "" {
            value = NSKeyedUnarchiver.unarchiveObject(with: keychain[data: key]!) as! [String: Any]
        }
        return value.count
    }
    
    public subscript(Index: String) -> Any? {
        get {
            if accessGroup != "" {
                return (NSKeyedUnarchiver.unarchiveObject(with: keychain[data: key]!) as! [String: Any])[Index]
            } else {
                return value[Index]
            }
        }
        
        set(newValue) {
            if accessGroup != "" {
                value = NSKeyedUnarchiver.unarchiveObject(with: keychain[data: key]!) as! [String: Any]
            }
            value[Index] = newValue
            _saveToKeychain()
        }
    }
    
    required public init(withKey: String) {
        key = withKey
        keychain = Keychain()
        accessGroup = ""
        super.init()
        if let _valueData = keychain[data: key] {
            value =  NSKeyedUnarchiver.unarchiveObject(with: _valueData) as! [String: Any]
        } else {
            _saveToKeychain()
        }
    }
    
    public init(withKey: String, accessGroup _ag: String) {
        key = withKey
        accessGroup = _ag
        keychain = Keychain(accessGroup: _ag)
        super.init()
        if let _valueData = keychain[data: key] {
            value =  NSKeyedUnarchiver.unarchiveObject(with: _valueData) as! [String: Any]
        } else {
            _saveToKeychain()
        }
    }
    
    public func clean() {
        value = [:]
        sync()
    }

    public func sync() {
        _saveToKeychain()
    }
    
    /// 保存数据
    ///
    /// Save data
    private func _saveToKeychain() {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        keychain[data: key] = data
    }
}
