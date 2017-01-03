import UIKit
import XCTest
import Nimble
@testable import KeyValueData

class KeyValueDataTests: XCTestCase {
    
    let testKey1 = "_testKey01_sdfghjkure"
    let testKey2 = "_testKey01_ssdfgkuytr"
    
    override func setUp() {
        super.setUp()
        
        UserDefaults.standard.removeObject(forKey: testKey1)
        UserDefaults.standard.removeObject(forKey: testKey2)
        
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
    
}
