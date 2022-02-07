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
                .responseDecodable(of: SeSACUser.self) { [weak self](response) in
                    guard let self = self else { return }
                    switch response.response?.statusCode {
                    case 200:
                        //가입 유저
                        switch response.result {
                        case .success(let user):
                            UserInfo.nickname = user.nick
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
                .response { [weak self](response) in
                    guard let self = self else { return }
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
        return Single<Int>.create { [weak self](single) in
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
                    guard let self = self else { return }
                    switch response.response?.statusCode {
                    case 200:
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
                        UserInfo.idToken = ""
                        UserInfo.fcmToken = ""
                        UserInfo.nickname = ""
                        UserInfo.gender = -1
                        UserInfo.birthday = ""
                        UserInfo.email = ""
                        UserInfo.phoneNumber = ""
                        UserInfo.signUpCompleted = false
                        UserInfo.verificationID = ""
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
    
    func apiErrorHandler(error: APIError) -> String {
        switch error {
        default:
            return APIError.disConnect.rawValue
        }
    }
}
