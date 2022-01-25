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
    
    func userVerification(verificationCode: String) -> Single<String> {
        return Single<String>.create { single in
            let verificationID = UserInfo.verificationID
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            
            Auth.auth().signIn(with: credential) { (_, error) in
                if error != nil {
                    print("userVerificationError!")
                    single(.failure(FirebaseAuthError.inCorrectVerificationCode))
                }
                
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error != nil {
                        print("getIDTokenForcingRefreshError!")
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
        UserInfo.phoneNumber = phoneNumber
        return Single<Void>.create { single in
            PhoneAuthProvider.provider()
              .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                  if let error = error {
                      print("requestVerificationCodeError!")
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
    
    func authErrorHandler(error: FirebaseAuthError) -> String {
        switch error {
        case .defaults:
            return FirebaseAuthError.defaults.rawValue
        case .tooManyRequest:
            return FirebaseAuthError.tooManyRequest.rawValue
        case .inCorrectVerificationCode:
            return FirebaseAuthError.inCorrectVerificationCode.rawValue
        default:
            return FirebaseAuthError.inCorrectVerificationCode.rawValue
        }
    }
}
