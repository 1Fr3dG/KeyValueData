//
//  KeyValueDictionaryInSqlite.swift
//
//  Created by Alfred Gao on 2017/1/4.
//
//

import SQLite

public class KeyValueDictionaryInSqlite: NSObject, KeyValueData {
    /// 数据库文件
    ///
    /// database file of ALL kvdata
    private var dbFile = NSHomeDirectory()+"/Documents/KeyValue.sqlite"
    
    public let key: String
    
    /// 数据库连接
    ///
    /// database connection
    private let db : Connection
    private let table : Table
    private let _key = Expression<String>("key")
    private let _value = Expression<Data>("value")
    
    /// 直接访问数据库
    ///
    /// Store data to database directly
    public var impontanceLevel: Int = 1 {
        didSet {
            impontanceLevel = 1
        }
    }
    
    public var keys: [String] {
        do {
            let value = try db.prepare(table)
            return value.map{return $0[_key]}
        } catch {
            return []
        }
    }
    
    public var count: Int {
        do {
            let _count = try db.scalar(table.select(_key.count))
            return _count
        } catch {
            return 0
        }
    }
    
    public subscript(Index: String) -> Any? {
        get {
            do {
                if let _record = try db.pluck(table.filter(_key == Index)) {
                    return NSKeyedUnarchiver.unarchiveObject(with: _record[_value])
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        
        set(newValue) {
            if newValue != nil {
                do {
                    if let _ = try db.pluck(table.filter(_key == Index)) {
                        _ = try db.run(table.filter(_key == Index).update(_value <- NSKeyedArchiver.archivedData(withRootObject: newValue as Any)))
                    } else {
                        _ = try db.run(table.insert(_key <- Index, _value <- NSKeyedArchiver.archivedData(withRootObject: newValue as Any)))
                    }
                } catch {
                }
            } else {
                do {
                    if try db.run(table.filter(_key == Index).delete()) > 0 {
                        
                    } else {
                        
                    }
                } catch {

                }
            }
        }
    }
    
    init(withKey: String, inDatabase: String) {
        key = withKey
        dbFile = NSHomeDirectory()+"/Documents/\(inDatabase).sqlite"
        let _dbname = dbFile
        do {
            db = try Connection(dbFile)
        } catch {
            db = try! Connection()
        }
        
        table = Table(key)
        super.init()
        do {
            try db.run(table.create(temporary: false, ifNotExists: true, block: { t in
                t.column(_key, unique: true)
                t.column(_value)
            }))
        } catch {

        }
    }
    
    convenience required public init(withKey: String) {
        self.init(withKey: withKey, inDatabase: "KeyValue")
    }
    
    deinit {
        
    }
    

    public func clean() {
        do {
            try db.run(table.drop(ifExists: true))
        } catch {

        }
    }
    

    public func sync() {
       
    }
}
