//
//  KeyValueDictionaryInDocumentsPlist.swift
//
//  Created by Alfred Gao on 2017/1/4.
//
//



/// 使用 Documents\*.plist 存储简单数据
///
/// Save kv-data to Documents\*.plist
public class KeyValueDictionaryInDocumentsPlist: NSObject, KeyValueData {

    public let key: String
    private let fileurl: URL
    
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
    
    public var impontanceLevel: Int = 1 {
        didSet {
            if impontanceLevel > 100 {
                impontanceLevel = 100
            } else if impontanceLevel < 1 {
                impontanceLevel = 1
            }
            
            sync()
            _valueEditTime = 0
        }
    }
    
    /// 数据改写次数
    ///
    /// Data write count
    private var _valueEditTime = 0
    
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
        
        do {
            let _pathurl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            fileurl = _pathurl.appendingPathComponent("\(key).plist", isDirectory: false)
        } catch {
            fileurl = URL(fileURLWithPath: NSHomeDirectory()+"/\(key).plist")
        }
        if let _value = NSDictionary(contentsOf: fileurl) {
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
            do {
                try NSDictionary(dictionary: value).write(to: fileurl)
            } catch {
                
            }
        _valueEditTime = 0
    }
}
