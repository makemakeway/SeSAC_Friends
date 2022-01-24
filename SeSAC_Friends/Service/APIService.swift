//
//  APIService.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/24.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: Error {
    case tokenExpired
    case serverError
    case clientError
    case invalidNickname
    case unKnowned
}

class APIService {
    static let shared = APIService()
    
    private init() {
        
    }
    
    func getUser(idToken: String) -> Single<Int> {
        return Single<Int>.create { single in
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
}
