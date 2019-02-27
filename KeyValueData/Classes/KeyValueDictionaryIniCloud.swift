//
//  KeyValueDictionaryIniCloud.swift
//  KeyValueData
//
//  Created by 高宇 on 2019/2/27.
//

import Foundation

public class KeyValueDictionaryIniCloud: NSObject, KeyValueData {
    
    public let key: String
    
    /// iCloud中的数据每次直接写入系统
    ///
    /// Force write to iCloud (local storage) directly
    public var impontanceLevel: Int = 1 {
        didSet {
            if impontanceLevel > 256 {
                impontanceLevel = 256
            } else if impontanceLevel < 1 {
                impontanceLevel = 1
            }
            
            sync()
            _valueEditTime = 0
        }
    }
    
    /// 数据改写次数
    ///
    /// value changed count
    private var _valueEditTime = 0
    
    /// 数据
    ///
    /// raw data
    var value: [String: Any] = [:] {
        didSet {
            _valueEditTime += 1
            if _valueEditTime >= impontanceLevel {
                sync()
                _valueEditTime = 0
            }
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
        if let _value = NSUbiquitousKeyValueStore.default.dictionary(forKey: key) {
            value = _value
        } else {
            value = [:]
        }
    }
    
    deinit {
        sync()
    }
    
    public func clean() {
        value = [:]
        sync()
    }
    
    public func sync() {
        NSUbiquitousKeyValueStore.default.set(value, forKey: key)
    }
}
