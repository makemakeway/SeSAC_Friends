//
//  FirebaseAuthService.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import Foundation
import FirebaseAuth
import RxSwift


enum FirebaseAuthError: String, Error {
    case defaults = "에러가 발생했습니다. 잠시 후 다시 시도해주세요"
    case tooManyRequest = "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
    case inCorrectVerificationCode = "전화 번호 인증 실패"
    case idTokenRequestFailed
}

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {
        
    }
    
    func userVerificaiton(verificaitonCode: String) -> Single<String> {
        return Single<String>.create { single in
            let verificationID = UserInfo.verificationID
            
            let credential = PhoneAuthProvider.provider().credential(
              withVerificationID: verificationID,
              verificationCode: verificaitonCode
            )
            
            Auth.auth().signIn(with: credential) { (_, error) in
                if error != nil {
                    single(.failure(FirebaseAuthError.inCorrectVerificationCode))
                    return
                }
                
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        single(.failure(FirebaseAuthError.idTokenRequestFailed))
                    }
                    if let idToken = idToken {
                        single(.success(idToken))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func requestVerificationCode(phoneNumber: String) -> Single<Void> {
        return Single<Void>.create { single in
            PhoneAuthProvider.provider()
              .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                  if let error = error {
                      single(.failure(error))
                      return
                  }
                  if let verificationID = verificationID {
                      UserInfo.verificationID = verificationID
                      single(.success(()))
                  }
              }
            return Disposables.create()
        }
    }
    
    func authErrorHandler(error: Error) -> String {
        let authError = error as NSError
        switch authError.code {
        case 17010:  // 너무 많은 요청
            return FirebaseAuthError.tooManyRequest.rawValue
        case 17044:  // 잘못된 코드 입력
            return FirebaseAuthError.inCorrectVerificationCode.rawValue
        case 17051:  // 코드 유효기간 만료
            return FirebaseAuthError.inCorrectVerificationCode.rawValue
        default:
            return FirebaseAuthError.defaults.rawValue
        }
    }
    
//    func verificationUser(verificaitonCode: String) -> Single<AuthDataResult> {
//
//        return Single<AuthDataResult>.create { single in
//            let verificationID = UserInfo.verificationID
//            
//            let credential = PhoneAuthProvider.provider().credential(
//              withVerificationID: verificationID,
//              verificationCode: verificaitonCode
//            )
//
//            Auth.auth().signIn(with: credential) { (result, error) in
//                if let error = error {
//                    single(.failure(error))
//                }
//                if let result = result {
//                    single(.success(result))
//                }
//            }
//            return Disposables.create()
//        }
//    }
}
