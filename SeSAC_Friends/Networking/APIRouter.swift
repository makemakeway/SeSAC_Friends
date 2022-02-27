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
    case myQueueState
    case hobbyRequest(uid: String)
    case hobbyAccept(uid: String)
    case chatTo(uid: String, text: String)
    case fetchChatList(uid: String, date: String)
    
    private var method: HTTPMethod {
        switch self {
        case .login, .myQueueState, .fetchChatList:
            return .get
        case .signUp, .withdraw, .updateMyPage, .startRequestFriends, .searchRequestFriends, .hobbyAccept, .hobbyRequest, .chatTo:
            return .post
        case .updateFCMToken:
            return .put
        case .stopRequestFriends:
            return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .login, .signUp:
            return "user"
        case .withdraw:
            return "user/withdraw"
        case .updateFCMToken:
            return "user/update_fcm_token"
        case .updateMyPage:
            return "user/update/mypage"
        case .startRequestFriends, .stopRequestFriends:
            return "queue"
        case .searchRequestFriends:
            return "queue/onqueue"
        case .myQueueState:
            return "queue/myQueueState"
        case .hobbyAccept:
            return "queue/hobbyaccept"
        case .hobbyRequest:
            return "queue/hobbyrequest"
        case .chatTo(let uid, _):
            return "chat/\(uid)"
        case .fetchChatList(let uid, let date):
            return "chat/\(uid)?lastchatDate=\(date)"
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
        case .myQueueState:
            return nil
        case .hobbyAccept(let uid), .hobbyRequest(let uid):
            return [CustomKey.APIParameterKey.otherUid: uid]
        case .chatTo(_, let text):
            return [CustomKey.APIParameterKey.chat: text]
        case .fetchChatList(let uid, _):
            return [CustomKey.APIParameterKey.from: uid]
        }
    }
    
    private var encoding: ParameterEncoding {
        let encoding = URLEncoding(destination: .httpBody, arrayEncoding: .noBrackets)
        return encoding
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try CustomKey.ProductionServer.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        request.setValue(ContentType.form.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue(UserInfo.idToken, forHTTPHeaderField: HTTPHeaderField.idToken.rawValue)
        
        if let parameters = parameters {
            request = try encoding.encode(request, with: parameters)
        }
        
        return request
    }
}
