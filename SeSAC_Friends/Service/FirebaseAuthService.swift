//
//  FirebaseAuthService.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import Foundation
import FirebaseAuth


enum FirebaseAuthError: String, Error {
    case defaults = "에러가 발생했습니다. 잠시 후 다시 시도해주세요"
    case tooManyRequest = "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
    case inCorrectVerificationCode = "전화 번호 인증 실패"
}

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {
        
    }
    
    func requestVerificationCode(phoneNumber: String, handler: @escaping (Result<String,Error>) -> Void) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
              if let error = error {
                  handler(.failure(error))
                  return
              }
              if let verificationID = verificationID {
                  UserInfo.verificationID = verificationID
                  handler(.success(verificationID))
              }
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
    
    func verificationUser(verificaitonCode: String, handler: @escaping (Result<AuthDataResult,Error>) -> Void) {
        let verificationID = UserInfo.verificationID
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificaitonCode
        )

        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.code)
                print(error.localizedDescription)
                handler(.failure(error))
            }
            if let result = result {
                handler(.success(result))
            }
        }
    }
}
