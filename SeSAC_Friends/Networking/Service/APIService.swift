//
//  APIService.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/24.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: String, Error {
    case tokenExpired = "토큰 갱신에 실패했습니다. 잠시 후 다시 시도해주세요."
    case serverError
    case clientError
    case invalidNickname = "해당 닉네임은 사용할 수 없습니다."
    case unKnownedUser
    case disConnect = "네트워크 연결이 원활하지 않습니다. 연결상태 확인 후 다시 시도해 주세요!"
    case tooLongWating = "오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다"
}

final class APIService {
    static let shared = APIService()
    
    private let disposeBag = DisposeBag()
    
    private init() {
        
    }
    
    func logIn() -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            AF.request(APIRouter.login)
                .validate()
                .responseDecodable(of: SeSACUser.self) { (response) in
                    switch response.response?.statusCode {
                    case 200:
                        //가입 유저
                        switch response.result {
                        case .success(let user):
                            UserInfo.nickname = user.nick
                            UserInfo.gender = user.gender
                            UserInfo.birthday = user.birth
                            UserInfo.email = user.email
                            UserInfo.fcmToken = user.fcMtoken
                            UserInfo.phoneNumber = user.phoneNumber
                            UserInfo.signUpCompleted = true
                        default:
                            print("디코딩 실패??")
                        }
                        single(.success(200))
                    case 406:
                        //미가입 유저
                        single(.success(406))
                    case 401:
                        //토큰 만료
                        single(.failure(APIError.tokenExpired))
                    case 500:
                        single(.failure(APIError.serverError))
                    case 501:
                        single(.failure(APIError.clientError))
                    default:
                        single(.failure(APIError.unKnownedUser))
                    }
                }
            return Disposables.create()
        }
    }
    
    func signUp() -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.signUp(phoneNumber: UserInfo.phoneNumber,
                                        fcmToken: UserInfo.fcmToken,
                                        nickname: UserInfo.nickname,
                                        birth: UserInfo.birthday,
                                        email: UserInfo.email,
                                        gender: UserInfo.gender))
                .validate()
                .response { (response) in
                    switch response.response?.statusCode {
                    case 200:
                        //회원가입 성공
                        print("회원가입 성공!")
                        UserInfo.signUpCompleted = true
                        single(.success(200))
                    case 201:
                        //이미 가입한 유저
                        print("이미 가입한 유저")
                        single(.success(201))
                    case 202:
                        //사용할 수 없는 닉네임
                        print("닉네임 사용 불가")
                        single(.failure(APIError.invalidNickname))
                    case 401:
                        //토큰 만료
                        single(.failure(APIError.tokenExpired))
                    case 500:
                        single(.failure(APIError.serverError))
                    case 501:
                        single(.failure(APIError.clientError))
                    default:
                        single(.failure(APIError.unKnownedUser))
                    }
                }
            return Disposables.create()
        }
    }
    
    func getUserData(idToken: String) -> Single<SeSACUser> {
        return Single<SeSACUser>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.login)
                .validate()
                .responseDecodable(of: SeSACUser.self) { (response) in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        single(.success(value))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 401:
                            single(.failure(APIError.tokenExpired))
                        case 406:
                            single(.failure(APIError.unKnownedUser))
                        case 500:
                            single(.failure(APIError.serverError))
                        default:
                            single(.failure(APIError.clientError))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func updateMypage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, hobby: String) -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.updateMyPage(searchable: searchable,
                                              ageMin: ageMin,
                                              ageMax: ageMax,
                                              gender: gender,
                                              hobby: hobby))
                .validate()
                .response { response in
                    switch response.response?.statusCode {
                    case 200:
                        UserInfo.gender = gender
                        single(.success(200))
                    case 401:
                        single(.failure(APIError.tokenExpired))
                    case 406:
                        single(.failure(APIError.unKnownedUser))
                    case 500:
                        single(.failure(APIError.serverError))
                    default:
                        single(.failure(APIError.clientError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func withdraw() -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.withdraw)
                .validate()
                .response { response in
                    switch response.response?.statusCode {
                    case 200:
                        UserInfo.setToDefaults()
                        single(.success(200))
                    case 401:
                        single(.failure(APIError.tokenExpired))
                    case 406:
                        single(.failure(APIError.unKnownedUser))
                    default:
                        single(.failure(APIError.serverError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchFriends(region: Int, lat: Double, long: Double) -> Single<Friends> {
        return Single.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.searchRequestFriends(region: region, lat: lat, long: long))
                .validate()
                .responseDecodable(of: Friends.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(_):
                        switch response.response?.statusCode {
                        case 401:
                            single(.failure(APIError.tokenExpired))
                        case 406:
                            single(.failure(APIError.unKnownedUser))
                        case 500:
                            single(.failure(APIError.serverError))
                        default:
                            single(.failure(APIError.clientError))
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func startRequestFriends(type: Int = 2, region: Int, lat: Double, long: Double, hf: [String]) -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            AF.request(APIRouter.startRequestFriends(type: type,
                                                     region: region,
                                                     lat: lat,
                                                     long: long,
                                                     hf: hf))
                .validate()
                .response { response in
                    switch response.response?.statusCode {
                    case 200:
                        single(.success(200))
                    case 201:
                        single(.success(201))
                    case 203:
                        single(.success(203))
                    case 204:
                        single(.success(204))
                    case 205:
                        single(.success(205))
                    case 206:
                        single(.success(206))
                    case 401:
                        single(.failure(APIError.tokenExpired))
                    case 406:
                        single(.failure(APIError.unKnownedUser))
                    case 500:
                        single(.failure(APIError.serverError))
                    default:
                        single(.failure(APIError.clientError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func getMyQueueState() -> Single<UserMatchingState> {
        return Single.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.myQueueState)
                .validate()
                .responseDecodable(of: UserMatchingState.self) { response in
                    switch response.response?.statusCode {
                    case 200:
                        switch response.result {
                        case .success(let state):
                            single(.success(state))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    case 201:
                        single(.failure(APIError.tooLongWating))
                    case 401:
                        single(.failure(APIError.tokenExpired))
                    case 406:
                        single(.failure(APIError.unKnownedUser))
                    case 500:
                        single(.failure(APIError.serverError))
                    default:
                        single(.failure(APIError.clientError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func stopSearchSesac() -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.stopRequestFriends)
                .validate()
                .response { response in
                    switch response.response?.statusCode {
                    case 200:
                        single(.success(200))
                    case 201:
                        single(.success(201))
                    case 401:
                        single(.failure(APIError.tokenExpired))
                    case 406:
                        single(.failure(APIError.unKnownedUser))
                    case 500:
                        single(.failure(APIError.serverError))
                    default:
                        single(.failure(APIError.clientError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func hobbyRequest(uid: String) -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            
            AF.request(APIRouter.hobbyRequest(uid: uid))
                .validate()
                .response { response in
                    switch response.response?.statusCode {
                    case 200:
                        single(.success(200))
                    case 201:
                        single(.success(201))
                    case 202:
                        single(.success(202))
                    case 401:
                        single(.failure(APIError.tokenExpired))
                    case 406:
                        single(.failure(APIError.unKnownedUser))
                    case 500:
                        single(.failure(APIError.serverError))
                    default:
                        single(.failure(APIError.clientError))
                    }
                }
            return Disposables.create()
        }
    }
    
    func apiErrorHandler(error: APIError) -> String {
        switch error {
        default:
            return APIError.disConnect.rawValue
        }
    }
}
