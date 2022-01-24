//
//  UserDefaultsWrapper.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    private let key: String
    private let defaultValue: Value
    
    
    init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

class UserInfo {
    @UserDefault(key: "verificationID", defaultValue: "")static var verificationID: String
    @UserDefault(key: "nickname", defaultValue: "")static var nickname: String
    @UserDefault(key: "birthday", defaultValue: "")static var birthday: String
    @UserDefault(key: "gender", defaultValue: "")static var gender: String
    @UserDefault(key: "firstRun", defaultValue: true)static var firstRun: Bool
    @UserDefault(key: "phoneNumber", defaultValue: "")static var phoneNumber: String
}
