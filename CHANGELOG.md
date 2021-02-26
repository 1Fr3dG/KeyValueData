# KeyValueData
用来存储 Key-Value 型数据。可针对不同情况使用不同的后端存储。

Manage key-value data with same protocol, for kinds of backends.

## LAST
[![CI Status](http://img.shields.io/travis/1Fr3dG/KeyValueData.svg?style=flat)](https://travis-ci.org/1fr3dg/KeyValueData)
[![Version](https://img.shields.io/cocoapods/v/KeyValueData.svg?style=flat)](http://cocoapods.org/pods/KeyValueData)
[![License](https://img.shields.io/cocoapods/l/KeyValueData.svg?style=flat)](http://cocoapods.org/pods/KeyValueData)
[![Platform](https://img.shields.io/cocoapods/p/KeyValueData.svg?style=flat)](http://cocoapods.org/pods/KeyValueData)

* Change ios.deployment_target to 14.1
* Update podspec to use updated pods (KeychainAccess)

# 1.3.0
* Change ios.deployment_target to 11.0
* Add iCloud as backend storage
	* Note there is a limitation of iCloud data size, it is not for 'data' but configuration
* Change impontanceLevel to 1 for all backend, this will cause sync() on every data set. You can still change this number

# 1.2.0
* Change project to support Swift 4

# 1.1.0
* Change ios.deployment_target to 9.0

# 1.0.5
* KeyChain with accessGroup will reload data before **EVERY** get / set
	* to reduce data conflict between two sessions with same key/accessGroup
	* technically, one session loads data between another session's loading & saving will still cause confliction. but we **IDEALLY ASSUME** that will not happen
	* it affact performance a little, tachnically. `KeyValueDictionaryInKeychain(withKey:)` without accessGroup still use old methodlogy : **read from cache, write through**
	* also, as you may know, you should never store big data to keychain

# 1.0.3
* Enable accessGroup support for KeyChain
	* `public init(withKey: String, accessGroup: String)`

# 1.0.1
* Enable define database for SQLite backend

# 1.0.0
* Re-structured old code