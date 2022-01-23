//
//  AuthViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import FirebaseAuth

class RequestAuthViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let input = Input()
    let output = Output()
    
    struct Input {
        let textFieldText = PublishSubject<String>()
        let tapAuthRequestButton = PublishSubject<Void>()
        let tapPhoneNumberTextField = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let goToLoginView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let phoneNumberText = PublishRelay<String>()
    }
    
    func transForm() {
        input.tapPhoneNumberTextField
            .withUnretained(self)
            .bind { (owner, _) in
                owner.output.textFieldState.accept(.focus)
            }
            .disposed(by: disposeBag)
        
        input.textFieldText
            .map {
                let phoneNumber = $0.replacingOccurrences(of: "-", with: "")
                return phoneNumber.count > 9
            }
            .bind(to: output.isButtonEnable)
            .disposed(by: disposeBag)
        
        input.textFieldText
            .withUnretained(self)
            .map { (owner, text) in
                owner.textToPhoneNumber(text: text)
            }
            .bind(to: output.phoneNumberText)
            .disposed(by: disposeBag)
        
        input.tapAuthRequestButton.withLatestFrom(output.phoneNumberText)
            .withUnretained(self)
            .bind { (owner, text) in
                // MARK: 핸드폰 번호 유효성 검사 && Auth 리퀘스트 여기서 구현하면 됨
                if owner.phoneNumberIsValid(text: text) {
                    
//                    owner.requestAuthorizaionNumber(phoneNumber: "+82 " + text)
                    
                    owner.output.goToLoginView.accept(())
                } else {
                    owner.output.errorMessage.accept("잘못된 전화번호 형식입니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func requestAuthorizaionNumber(phoneNumber: String) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if let error = error {
                print(error.localizedDescription)
                return
              }
              if let verificationID = verificationID {
                  UserDefaults.standard.set(verificationID, forKey: "verificationID")
              }
          }
    }
    
    func textToPhoneNumber(text: String) -> String {
        var temp = ""
        let numberText = text.replacingOccurrences(of: "-", with: "")
        
        if numberText.count <= 3 {
            return numberText
        } else if numberText.count <= 6 {
            let first = numberText.index(numberText.startIndex, offsetBy: 2)
            temp += numberText[...first]
            temp += "-"
            temp += numberText[numberText.index(after: first)...]
            return temp
        } else if numberText.count <= 10 {
            let first = numberText.index(numberText.startIndex, offsetBy: 2)
            temp += numberText[...first]
            temp += "-"
            let second = numberText.index(first, offsetBy: 3)
            temp += numberText[numberText.index(after: first)...second]
            temp += "-"
            temp += numberText[numberText.index(after: second)...]
            return temp
        } else {
            let first = numberText.index(numberText.startIndex, offsetBy: 2)
            temp += numberText[...first]
            temp += "-"
            let second = numberText.index(first, offsetBy: 4)
            let last = numberText.index(second, offsetBy: 4)
            temp += numberText[numberText.index(after: first)...second]
            temp += "-"
            temp += numberText[numberText.index(after: second)...last]
            return temp
        }
    }
    
    func phoneNumberIsValid(text: String) -> Bool {
        let numbers = text.replacingOccurrences(of: "-", with: "")
        
        if !(numbers.hasPrefix("01")) {
            return false
        } else if numbers.count != 10 && numbers.count != 11 {
            return false
        }
        return true
    }
    
    init() {
        transForm()
    }
}
