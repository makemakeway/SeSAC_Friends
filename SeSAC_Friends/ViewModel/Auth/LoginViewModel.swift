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
            .asObservable()
            .map { $0.count >= 6 }
            .bind(to: output.isButtonEnable)
            .disposed(by: disposeBag)
        
        input.validationNumberText
            .asObservable()
            .map { [weak self] in
                self?.restrictTextCount(text: $0) ?? ""
            }
            .bind(to: output.textFieldText)
            .disposed(by: disposeBag)
        
        input.tapCheckValidationButton.withLatestFrom(output.textFieldText)
            .bind { [weak self](text) in
                guard let self = self else { return }
                // MARK: 여기서 인증코드 입력했을 때 코드 작성
                print(text)
                
                if text.count == 6 && Int(text) != nil {
                    
                    
                    // 번호로 가입되어 있다면
                    
                    // 가입되어 있지 않다면
                    self.output.goToNicknameView.accept(())
                } else {
                    self.output.errorMessage.accept("올바른 형식의 인증번호를 입력해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        input.tapValidationNumberTextField
            .bind { [weak self] in
                guard let self = self else { return }
                self.output.textFieldState.accept(.focus)
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
