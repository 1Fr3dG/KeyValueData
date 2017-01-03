//
//  KeyValueDictionaryInKeychain.swift
//
//  Created by Alfred Gao on 2017/1/4.
//
//

import KeychainAccess

public class KeyValueDictionaryInKeychain: NSObject, KeyValueData {

    public let key: String
    
    /// Keychain 中的数据每次写强制存储
    ///
    /// Force write to keychain directly
    public var impontanceLevel: Int = 1
    
    var value: [String: Any] = [:] {
        didSet {
            _saveToKeychain()
        }
    }
    
    public var keys: [String] {
        return value.map{(key, value) -> String in return key}
    }
    
    public var count: Int {
        return value.count
    }
    
    public subscript(Index: String) -> Any? {
        get {
            return value[Index]
        }
        
        set(newValue) {
            value[Index] = newValue
        }
    }
    
    required public init(withKey: String) {
        key = withKey
        let keychain = Keychain()
        if let _valueData = keychain[data: key] {
            value =  NSKeyedUnarchiver.unarchiveObject(with: _valueData) as! [String: Any]
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
        let keychain = Keychain().synchronizable(true)
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        keychain[data: key] = data
    }
}
