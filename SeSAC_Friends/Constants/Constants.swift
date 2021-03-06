//
//  Constants.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/04.
//

import Foundation
import CoreLocation

struct CustomKey {
    struct ProductionServer {
        static let baseURL = "http://test.monocoding.com:35484/"
    }
    
    struct APIParameterKey {
        static let phoneNumber = "phoneNumber"
        static let fcmToken = "FCMtoken"
        static let nickname = "nick"
        static let birth = "birth"
        static let email = "email"
        static let gender = "gender"
        static let searchable = "searchable"
        static let ageMin = "ageMin"
        static let ageMax = "ageMax"
        static let hobby = "hobby"
        static let type = "type"
        static let region = "region"
        static let lat = "lat"
        static let long = "long"
        static let hf = "hf"
        static let otherUid = "otheruid"
        static let chat = "chat"
        static let from = "from"
    }
}

struct DefaultValue {
    static let location = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case idToken = "idtoken"
}

enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}
