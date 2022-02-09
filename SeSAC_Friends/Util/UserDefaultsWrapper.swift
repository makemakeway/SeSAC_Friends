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
    @UserDefault(key: "idToken", defaultValue: "")static var idToken: String
    @UserDefault(key: "nickname", defaultValue: "")static var nickname: String
    @UserDefault(key: "birthday", defaultValue: "")static var birthday: String
    @UserDefault(key: "gender", defaultValue: 100)static var gender: Int
    @UserDefault(key: "signUpCompleted", defaultValue: false)static var signUpCompleted: Bool
    @UserDefault(key: "phoneNumber", defaultValue: "")static var phoneNumber: String
    @UserDefault(key: "email", defaultValue: "")static var email: String
    @UserDefault(key: "FCMToken", defaultValue: "")static var fcmToken: String
    @UserDefault(key: "userState", defaultValue: FloatingButtonState.normal)static var userState: FloatingButtonState
}
