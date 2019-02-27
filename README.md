# KeyValueData

[![CI Status](http://img.shields.io/travis/1Fr3dG/KeyValueData.svg?style=flat)](https://travis-ci.org/1fr3dg/KeyValueData)
[![Version](https://img.shields.io/cocoapods/v/KeyValueData.svg?style=flat)](http://cocoapods.org/pods/KeyValueData)
[![License](https://img.shields.io/cocoapods/l/KeyValueData.svg?style=flat)](http://cocoapods.org/pods/KeyValueData)
[![Platform](https://img.shields.io/cocoapods/p/KeyValueData.svg?style=flat)](http://cocoapods.org/pods/KeyValueData)

用来存储 Key-Value 型数据。可针对不同情况使用不同的后端存储。

Manage key-value data with same protocol, for kinds of backends.

## Example

~~~swift
// Load/Create data

var _dataInKeyChain: KeyValueData = KeyValueDictionaryInKeychain(withKey: "account")

var _dataInUserDefaults: KeyValueData = KeyValueDictionaryInUserDefaults(withKey: "account")

// Data in => NSHomeDirectory()+"/Documents/\(withKey).plist"
var _dataInPlist: KeyValueData = KeyValueDictionaryInDocumentsPlist(withKey: "account")

// Data in => NSHomeDirectory()+"/Documents/KeyValue.sqlite", table: withKey
var _dataInSQLite: KeyValueData = KeyValueDictionaryInSqlite(withKey: "account")

// Data in iCloud KV storage with key: withKey
var _dataIniCloud: KeyValueData = KeyValueDictionaryIniCloud(withKey: "account")

// set/get data from KV
_data["accountid"] = "12345678"
let id = _data["accountid"] as! String

// write data to disk
// this is not necessary for KeyChain/SQLite
_data.sync()

~~~

## Requirements

* iOS 11.0+

## Installation

可通过[CocoaPods](http://cocoapods.org)安装：

KeyValueData is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KeyValueData"
```

## Author

[Alfred Gao](http://alfredg.org), [alfredg@alfredg.cn](mailto:alfredg@alfredg.cn)

## License

KeyValueData is available under the MIT license. See the LICENSE file for more info.
