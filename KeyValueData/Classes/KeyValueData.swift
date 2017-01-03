//
//  KeyValueData.swift
//
//  Created by Alfred Gao on 2016/10/25.
//  Copyright © 2016年 Alfred Gao. All rights reserved.
//

import Foundation

/// 存储简单数据
///
/// Store Key-Value data
public protocol KeyValueData {
    
    /// 数据 key, 必须全应用唯一
    ///
    /// key, must be unique
    var key : String { get }
    
    /// 下标列表
    ///
    /// List of keys, so we can perform loop
    var keys : [String] { get }
    
    /// 数据重要性：数据改写多少次后写入闪存
    ///
    /// importence: auto save data after time of change
    var impontanceLevel: Int { get set}
    
    /// 数据数量
    ///
    /// count of key-value data
    var count: Int { get }
    
    /// 下标访问
    ///
    /// access the data by key
    /// - parameter Index: Key
    /// - returns: Value
    subscript(Index: String) -> Any? { get set }
    
    /// 使用 key 初始化一个存储单元
    ///
    /// init and load data
    init(withKey: String)
    
    /// 清除数据
    ///
    /// clean all data
    func clean()
    
    /// 强制数据存储
    ///
    /// force save data
    func sync()
}
