//
//  LoginViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/20.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

class LoginViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let validationNumberText = PublishSubject<String>()
        let tapCheckValidationButton = PublishSubject<Void>()
        let tapValidationNumberTextField = PublishSubject<Void>()
        let timerStart = BehaviorSubject(value: 180)
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let textFieldText = BehaviorRelay(value: "")
        let goToNicknameView = PublishRelay<Void>()
        let goToHomeView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let timerLabelText = BehaviorRelay(value: "05:00")
    }
    
    var input = Input()
    var output = Output()
    
    func restrictTextCount(text: String) -> String {
        var temp = ""
        
        if text.count < 6 {
            return text
        } else {
            
            let first = text.startIndex
            let last = text.index(first, offsetBy: 5)
            temp += text[first...last]
            return temp
        }
    }
    
    func transForm() {
        
        input.validationNumberText
            .map { $0.count >= 6 }
            .bind(to: output.isButtonEnable)
            .disposed(by: disposeBag)
        
        input.validationNumberText
            .withUnretained(self)
            .map { owner, text in
                owner.restrictTextCount(text: text)
            }
            .bind(to: output.textFieldText)
            .disposed(by: disposeBag)
        
        input.tapCheckValidationButton.withLatestFrom(output.textFieldText)
            .withUnretained(self)
            .bind(onNext: { (owner, text) in
                // MARK: 여기서 인증코드 입력했을 때 코드 작성
                if text.count == 6 && Int(text) != nil {
                    
                    
                    // 번호로 가입되어 있다면
                    
                    // 가입되어 있지 않다면
                    owner.output.goToNicknameView.accept(())
                } else {
                    owner.output.errorMessage.accept("올바른 형식의 인증번호를 입력해주세요.")
                }
            })
            .disposed(by: disposeBag)
        
        input.tapValidationNumberTextField
            .withUnretained(self)
            .bind { (owner, _) in
                owner.output.textFieldState.accept(.focus)
            }
            .disposed(by: disposeBag)
    }
    
    func verificationUser(verificaitonCode: String) {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificaitonCode
        )
        
        Auth.auth().signIn(with: credential) { result, error in
            
        }
    }
    
    init() {
        transForm()
    }
    
}
