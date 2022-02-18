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
    case disConnect = "네트워크 연결이 원활하지 않습니다. 연결상태 확인 후 다시 시도해 주세요!"
}

final class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {
        
    }
    
    func userVerification(verificationCode: String) -> Single<Bool> {
        return Single<Bool>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(FirebaseAuthError.disConnect))
            }
            
            let verificationID = UserInfo.verificationID
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            
            print("ID: \(verificationID)")
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil {
                    print(error)
                    print("ERROR: userVerificationError!")
                    single(.failure(FirebaseAuthError.inCorrectVerificationCode))
                }
                
                if result != nil {
                    single(.success(true))
                }
            }
            return Disposables.create()
        }
    }
    
    func getIdToken() -> Single<String> {
        return Single<String>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(FirebaseAuthError.disConnect))
            }
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if error != nil {
                    print("ERROR: getIDTokenForcingRefreshError!")
                    single(.failure(FirebaseAuthError.idTokenRequestFailed))
                }
                if let idToken = idToken {
                    print(idToken)
                    UserInfo.idToken = idToken
                    single(.success(idToken))
                }
            }
            return Disposables.create()
        }
    }
    
    func requestVerificationCode(phoneNumber: String) -> Single<Void> {
        UserInfo.phoneNumber = phoneNumber
        return Single<Void>.create { single in
            if !(Connectivity.isConnectedToInternet) {
                single(.failure(FirebaseAuthError.disConnect))
            }
            PhoneAuthProvider.provider()
              .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                  if let error = error {
                      print("ERROR: requestVerificationCodeError!")
                      single(.failure(error))
                      return
                  }
                  if let verificationID = verificationID {
                      print("verificationID = \(verificationID)")
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
        case .disConnect:
            return FirebaseAuthError.disConnect.rawValue
        default:
            return FirebaseAuthError.inCorrectVerificationCode.rawValue
        }
    }
}
