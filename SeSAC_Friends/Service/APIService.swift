//
//  APIService.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/24.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseAuth

enum APIError: String, Error {
    case tokenExpired = "토큰 갱신에 실패했습니다. 잠시 후 다시 시도해주세요."
    case serverError
    case clientError
    case invalidNickname = "해당 닉네임은 사용할 수 없습니다."
    case unKnowned
    case disConnect = "네트워크 연결이 원활하지 않습니다. 연결상태 확인 후 다시 시도해 주세요!"
}

class APIService {
    static let shared = APIService()
    
    private let disposeBag = DisposeBag()
    
    private init() {
        
    }
    
    func getUser(idToken: String) -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            let url = EndPoint.user.url
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
                "idtoken": idToken
            ]
            AF.request(url, method: .get, headers: headers)
                .validate()
                .response { response in
                    switch response.response?.statusCode {
                    case 201:
                        //미가입 유저
                        single(.success(201))
                    case 200:
                        //가입 유저
                        single(.success(200))
                    case 401:
                        //토큰 만료
                        single(.failure(APIError.tokenExpired))
                    case 500:
                        single(.failure(APIError.serverError))
                    case 501:
                        single(.failure(APIError.clientError))
                    default:
                        single(.failure(APIError.unKnowned))
                    }
                }
            return Disposables.create()
        }
    }
    
    func postUser() -> Single<Int> {
        return Single<Int>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(APIError.disConnect))
            }
            let url = EndPoint.user.url
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
                "idtoken": UserInfo.idToken
            ]
            
            let params: Parameters = [
                "phoneNumber" : UserInfo.phoneNumber,
                "FCMtoken": UserInfo.fcmToken,
                "nick": UserInfo.nickname,
                "birth": UserInfo.birthday,
                "email": UserInfo.email,
                "gender" : UserInfo.gender
            ]
            AF.request(url,
                       method: .post,
                       parameters: params,
                       encoding: URLEncoding(destination: .httpBody),
                       headers: headers)
                .validate()
                .response { [weak self](response) in
                    guard let self = self else { return }
                    switch response.response?.statusCode {
                    case 200:
                        //회원가입 성공
                        print("회원가입 성공!")
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
                        FirebaseAuthService.shared.getIdToken()
                            .subscribe { _ in
                                _ = self.postUser()
                            } onFailure: { error in
                                single(.failure(APIError.tokenExpired))
                            }
                            .disposed(by: self.disposeBag)
                    case 500:
                        single(.failure(APIError.serverError))
                    case 501:
                        single(.failure(APIError.clientError))
                    default:
                        single(.failure(APIError.unKnowned))
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
