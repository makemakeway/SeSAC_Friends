//
//  APIRouter.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/04.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {    
    case login
    case signUp(phoneNumber: String, fcmToken: String, nickname: String, birth: String, email: String, gender: Int)
    case withdraw
    case updateFCMToken(fcmToken: String)
    case updateMyPage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, hobby: String)
    case startRequestFriends(type: Int, region: Int, lat: Double, long: Double, hf: [String])
    case stopRequestFriends
    case searchRequestFriends(region: Int, lat: Double, long: Double)
    
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signUp, .withdraw, .updateMyPage, .startRequestFriends, .searchRequestFriends:
            return .post
        case .updateFCMToken:
            return .put
        case .stopRequestFriends:
            return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .login:
            return "user"
        case .signUp:
            return "user"
        case .withdraw:
            return "user/withdraw"
        case .updateFCMToken:
            return "user/update_fcm_token"
        case .updateMyPage:
            return "user/update/mypage"
        case .startRequestFriends:
            return "queue"
        case .stopRequestFriends:
            return "queue"
        case .searchRequestFriends:
            return "queue/onqueue"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .login:
            return nil
        case .signUp(let phoneNumber, let fcmToken, let nickname, let birth, let email, let gender):
            return [CustomKey.APIParameterKey.phoneNumber: phoneNumber,
                    CustomKey.APIParameterKey.fcmToken: fcmToken,
                    CustomKey.APIParameterKey.nickname: nickname,
                    CustomKey.APIParameterKey.birth: birth,
                    CustomKey.APIParameterKey.email: email,
                    CustomKey.APIParameterKey.gender: gender]
        case .withdraw:
            return nil
        case .updateFCMToken(let fcmToken):
            return [CustomKey.APIParameterKey.fcmToken: fcmToken]
        case .updateMyPage(let searchable, let ageMin, let ageMax, let gender, let hobby):
            return [CustomKey.APIParameterKey.searchable: searchable,
                    CustomKey.APIParameterKey.ageMin: ageMin,
                    CustomKey.APIParameterKey.ageMax: ageMax,
                    CustomKey.APIParameterKey.gender: gender,
                    CustomKey.APIParameterKey.hobby: hobby]
        case .startRequestFriends(let type, let region, let lat, let long, let hf):
            return [CustomKey.APIParameterKey.type: type,
                    CustomKey.APIParameterKey.region: region,
                    CustomKey.APIParameterKey.lat: lat,
                    CustomKey.APIParameterKey.long: long,
                    CustomKey.APIParameterKey.hf: hf]
        case .stopRequestFriends:
            return nil
        case .searchRequestFriends(let region, let lat, let long):
            return [CustomKey.APIParameterKey.region: region,
                    CustomKey.APIParameterKey.lat: lat,
                    CustomKey.APIParameterKey.long: long]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try CustomKey.ProductionServer.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        request.setValue(ContentType.form.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue(UserInfo.idToken, forHTTPHeaderField: HTTPHeaderField.idToken.rawValue)
        
        if let parameters = parameters {
            
            let formDataArray = parameters.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }) as [String]
        
            let formDataString = formDataArray.joined(separator: "&")
            let formEncodedData = formDataString.data(using: .utf8)
            
            request.httpBody = formEncodedData
        }
        
        return request
    }
}
