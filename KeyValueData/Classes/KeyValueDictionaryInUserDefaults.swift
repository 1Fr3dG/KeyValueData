//
//  KeyValueDictionaryInUserDefaults.swift
//
//  Created by Alfred Gao on 2017/1/3.
//
//

import Foundation

public class KeyValueDictionaryInUserDefaults: NSObject, KeyValueData {

    public let key: String
    
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
            UserDefaults.standard.set(value, forKey: key)
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
        if let _value = UserDefaults.standard.object(forKey: key) {
            value =  _value as! [String: Any]
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
        UserDefaults.standard.synchronize()
    }
}
