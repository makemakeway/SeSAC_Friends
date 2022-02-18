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
            UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct CustomUserDefault<Value: Codable> {
    private let key: String
    private let defaultValue: Value
    
    init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get {
            let decoder = PropertyListDecoder()
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return defaultValue }
            let value = try? decoder.decode(Value.self, from: data)
            return value ?? defaultValue
        }
        set {
            let encoder = PropertyListEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.setValue(data ?? defaultValue, forKey: key)
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
    @CustomUserDefault(key: "userState", defaultValue: FloatingButtonState.normal)static var userState: FloatingButtonState
    @CustomUserDefault(key: "position", defaultValue: UserLocation(lat: 37.517819364682694, lng: 126.88647317074734))static var userPosition: UserLocation
    @CustomUserDefault(key: "mapPosition", defaultValue: UserLocation(lat: 37.517819364682694, lng: 126.88647317074734))static var mapPosition: UserLocation
    
    static func setToDefaults() {
        self.birthday = ""
        self.email = ""
        self.fcmToken = ""
        self.gender = -1
        self.idToken = ""
        self.nickname = ""
        self.phoneNumber = ""
        self.signUpCompleted = false
        self.userState = FloatingButtonState.normal
        self.verificationID = ""
        self.userPosition = UserLocation(lat: 37.517819364682694, lng: 126.88647317074734)
        self.mapPosition = UserLocation(lat: 37.517819364682694, lng: 126.88647317074734)
    }
}
