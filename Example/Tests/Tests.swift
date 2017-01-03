import UIKit
import XCTest
import KeychainAccess
import SQLite
import Nimble
@testable import KeyValueData

class KeyValueDataTests: XCTestCase {
    
    let testKey1 = "_testKey01_sdfghjkure"
    let testKey2 = "_testKey01_ssdfgkuytr"
    
    override func setUp() {
        super.setUp()
        
        UserDefaults.standard.removeObject(forKey: testKey1)
        UserDefaults.standard.removeObject(forKey: testKey2)
        
        let keychain = Keychain()
        keychain[data:testKey1] = nil
        keychain[data:testKey2] = nil
        
        let filemanager = FileManager.default
        do {
            try filemanager.removeItem(atPath: NSHomeDirectory()+"/Documents/\(testKey1).plist")
        } catch {
        }
        
        do {
            try filemanager.removeItem(atPath: NSHomeDirectory()+"/Documents/\(testKey2).plist")
        } catch {
        }
        
        do {
            try filemanager.removeItem(atPath: NSHomeDirectory()+"/Documents/KeyValue.sqlite")
        } catch {

        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // UserDefaults
    func testInitWithNoDataShouldGetZeroDictionary() {
        let kvdata = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        expect(kvdata.value.count) == 0
        expect(kvdata.count) == 0
    }
    
    func testReadDataFromSavedDictionary() {
        let testDict: [String : Any] = ["K1" : "V1", "K2" : 2, "K3" : 3.3 as Float, "K4" : true]
        UserDefaults.standard.set(testDict, forKey: testKey1)
        let kvdata = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        
        expect(kvdata.count) == 4
        expect(kvdata["K1"] as? String) == "V1"
        expect(kvdata["K2"] as? Int) == 2
        expect(kvdata["K3"] as? Float) == 3.3
        expect(kvdata["K4"] as? Bool) == true
        expect(kvdata["K not there"]).to(beNil())
    }
    
    func testReloadDataFromSavedDictionary() {
        let testDict: [String : Any] = ["K1" : "V1", "K2" : 2, "K3" : 3.3 as Float, "K4" : true]
        let kvdata = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        kvdata.value = testDict
        // kvdata 数据设置完成
        expect(kvdata.count) == 4
        expect(kvdata["K1"] as? String) == "V1"
        expect(kvdata["K2"] as? Int) == 2
        expect(kvdata["K3"] as? Float) == 3.3
        expect(kvdata["K4"] as? Bool) == true
        expect(kvdata["K not there"]).to(beNil())
        // save
        kvdata.sync()
        // 创建新对象
        let kvdata1 = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        expect(kvdata1.count) == 4
        expect(kvdata1["K1"] as? String) == "V1"
        expect(kvdata1["K2"] as? Int) == 2
        expect(kvdata1["K3"] as? Float) == 3.3
        expect(kvdata1["K4"] as? Bool) == true
        expect(kvdata1["K not there"]).to(beNil())
    }
    
    func testChangeDictDataWillAffectUserDefaults() {
        expect(UserDefaults.standard.object(forKey: self.testKey1)).to(beNil())
        let kvdata = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        
        kvdata["K1"] = "V1"
        
        let data = UserDefaults.standard.object(forKey: self.testKey1) as? [String: Any]
        expect(data).notTo(beNil(), description: "存储过数据，UserDefautls 中数据不应为空")
        expect(data?["K1"]).notTo(beNil(), description: "存储过数据，UserDefautls 中对应 key 不应为空")
        expect(data?["K1"] as? String) == "V1"
    }
    
    func testAssignDictionaryToKTClassWillSaveAllDataToUserDefaults() {
        let testDict: [String : Any] = ["K1" : "V1", "K2" : 2, "K3" : 3.3 as Float, "K4" : true]
        expect(UserDefaults.standard.object(forKey: self.testKey1)).to(beNil())
        let kvdata = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        kvdata.value = testDict
        kvdata.sync()
        
        let data = UserDefaults.standard.object(forKey: self.testKey1) as? [String: Any]
        expect(data).notTo(beNil(), description: "存储过数据，UserDefautls 中数据不应为空")
        expect(data?.count) == 4
        expect(data?["K1"]).notTo(beNil(), description: "存储过数据，UserDefautls 中对应 key 不应为空")
        expect(data?["K1"] as? String) == "V1"
    }
    
    func testSettingImportanceNumberWillBeRestricted() {
        let kvdata = KeyValueDictionaryInUserDefaults(withKey: self.testKey1)
        kvdata.impontanceLevel = 999999
        expect(kvdata.impontanceLevel) == 256
        kvdata.impontanceLevel = -999999
        expect(kvdata.impontanceLevel) == 1
    }
    
    // Keychain test require entitlements
    func disabled_testInitWithNoDataShouldGetZeroDictionary_KeychainAsBackend() {
        let kvdata = KeyValueDictionaryInKeychain(withKey: self.testKey1)
        expect(kvdata.value.count) == 0
        expect(kvdata.count) == 0
    }
    
    func disabled_testReadDataFromSavedDictionary_KeychainAsBackend() {
        let testDict: [String : Any] = ["K1" : "V1", "K2" : 2, "K3" : 3.3 as Float, "K4" : true]
        let keychain = Keychain()
        let data = NSKeyedArchiver.archivedData(withRootObject: testDict)
        keychain[data: testKey1] = data
        let kvdata = KeyValueDictionaryInKeychain(withKey: self.testKey1)
        
        expect(kvdata.count) == 4
        expect(kvdata["K1"] as? String) == "V1"
        expect(kvdata["K2"] as? Int) == 2
        expect(kvdata["K3"] as? Float) == 3.3
        expect(kvdata["K4"] as? Bool) == true
        expect(kvdata["K not there"]).to(beNil())
    }
    
    func disabled_testReloadDataFromSavedDictionary_KeychainAsBackend() {
        let testDict: [String : Any] = ["K1" : "V1", "K2" : 2, "K3" : 3.3 as Float, "K4" : true]
        var kvdata = KeyValueDictionaryInKeychain(withKey: self.testKey1)
        kvdata.value = testDict
        // kvdata 数据设置完成
        expect(kvdata.count) == 4
        expect(kvdata["K1"] as? String) == "V1"
        expect(kvdata["K2"] as? Int) == 2
        expect(kvdata["K3"] as? Float) == 3.3
        expect(kvdata["K4"] as? Bool) == true
        expect(kvdata["K not there"]).to(beNil())
        // 删除对象
        kvdata = KeyValueDictionaryInKeychain(withKey: self.testKey2)
        // 创建新对象
        let ktdata1 = KeyValueDictionaryInKeychain(withKey: self.testKey1)
        expect(ktdata1.count) == 4
        expect(ktdata1["K1"] as? String) == "V1"
        expect(ktdata1["K2"] as? Int) == 2
        expect(ktdata1["K3"] as? Float) == 3.3
        expect(ktdata1["K4"] as? Bool) == true
        expect(ktdata1["K not there"]).to(beNil())
    }
    
    func disabled_testChangeDictDataWillAffectKeychain() {
        let keychain = Keychain()
        expect(keychain[data: self.testKey1]).to(beNil())
        let kvdata = KeyValueDictionaryInKeychain(withKey: self.testKey1)
        
        kvdata["K1"] = "V1"
        
        let data = keychain[data: testKey1]
        expect(data).notTo(beNil(), description: "存储过数据，Keychain 中数据不应为空")
        if data != nil {
            let dataDict = NSKeyedUnarchiver.unarchiveObject(with: data!) as! [String: Any]
            expect(dataDict["K1"]).notTo(beNil(), description: "存储过数据，Keychain 中对应 key 不应为空")
            expect(dataDict["K1"] as? String) == "V1"
        }
    }
    
    // plist
    func testInitWithNoDataShouldGetZeroDictionary_PlistAsBackend() {
        let kvdata = KeyValueDictionaryInDocumentsPlist(withKey: self.testKey1)
        expect(kvdata.value.count) == 0
        expect(kvdata.count) == 0
    }
    
    func testReloadDataFromSavedDictionary_PlistAsBackend() {
        let testDict: [String : Any] = ["K1" : "V1", "K2" : 2, "K3" : 3.3 as Float, "K4" : true]
        let kvdata = KeyValueDictionaryInDocumentsPlist(withKey: self.testKey1)
        kvdata.value = testDict
        // kvdata 数据设置完成
        expect(kvdata.count) == 4
        expect(kvdata["K1"] as? String) == "V1"
        expect(kvdata["K2"] as? Int) == 2
        expect(kvdata["K3"] as? Float) == 3.3
        expect(kvdata["K4"] as? Bool) == true
        expect(kvdata["K not there"]).to(beNil())
        // 删除对象
        kvdata.sync()
        // 创建新对象
        let ktdata1 = KeyValueDictionaryInDocumentsPlist(withKey: self.testKey1)
        expect(ktdata1.count) == 4
        expect(ktdata1["K1"] as? String) == "V1"
        expect(ktdata1["K2"] as? Int) == 2
        expect(ktdata1["K3"] as? Float) == 3.3
        expect(ktdata1["K4"] as? Bool) == true
        expect(ktdata1["K not there"]).to(beNil())
    }
    
    func testSettingImportanceNumberWillBeRestricted_PlistAsBackend() {
        let kvdata = KeyValueDictionaryInDocumentsPlist(withKey: self.testKey1)
        kvdata.impontanceLevel = 999999
        expect(kvdata.impontanceLevel) == 100
        kvdata.impontanceLevel = -999999
        expect(kvdata.impontanceLevel) == 1
    }
    
    func testSetValue10TimesCauseAutoSave_PlistAsBackend() {
        let kvdata = KeyValueDictionaryInDocumentsPlist(withKey: self.testKey1)
        for _key in 0..<15 {
            kvdata[String(_key)] = _key * _key
        }
        
        let ktdata1 = KeyValueDictionaryInDocumentsPlist(withKey: self.testKey1)
        expect((kvdata["5"] as! Int)) == 25
        expect((ktdata1["5"] as! Int)) == 25
        expect((kvdata["13"] as! Int)) == 169
        expect(ktdata1["13"]).to(beNil())
    }
    
    // sqlite
    func testInitWithNoDataShouldGetZeroDictionary_SqliteAsBackend() {
        let kvdata = KeyValueDictionaryInSqlite(withKey: self.testKey1)
        expect(kvdata.count) == 0
    }
    
    func testSaveDataAndLoadThem_SqliteAsBackend() {
        let kvdata = KeyValueDictionaryInSqlite(withKey: self.testKey1)
        // 设置数据
        kvdata["K1"] = "V1"
        kvdata["K2"] = 2 as Int
        kvdata["K3"] = 3.3 as Float
        kvdata["K4"] = true
        // 读取数据
        let ktdata1 = KeyValueDictionaryInSqlite(withKey: self.testKey1)
        expect(ktdata1.count) == 4
        expect(ktdata1["K1"] as? String) == "V1"
        expect(ktdata1["K2"] as? Int) == 2
        expect(ktdata1["K3"] as? Float) == 3.3
        expect(ktdata1["K4"] as? Bool) == true
        expect(ktdata1["K not there"]).to(beNil())
    }
    
}
