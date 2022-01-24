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
import RxCocoa

class LoginViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let validationNumberText = PublishSubject<String>()
        let tapCheckValidationButton = PublishSubject<Void>()
        let tapValidationNumberTextField = PublishSubject<Void>()
        let tapReRequestButton = PublishSubject<Void>()
        let timerStart = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let textFieldText = BehaviorRelay(value: "")
        let goToNicknameView = PublishRelay<Void>()
        let goToHomeView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let timerLabelText = BehaviorRelay(value: "01:00")
        let requestCodeAgain = PublishRelay<Void>()
    }
    
    var input = Input()
    var output = Output()
    
    var counterLimit = 60
    
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
    
    func secToTime(sec: Int) -> String {
        let minute = sec / 60
        let second = sec % 60
        var text = ""
        
        if second < 10 {
           text = "0\(minute):0\(second)"
        } else {
            text = "0\(minute):\(second)"
        }
        
        return text
    }
    
    func transForm() {
        
        input.timerStart
            .flatMapLatest { Driver<Int>.timer(.seconds(0), period: .seconds(1)) }
            .map { self.counterLimit - $0 }
            .filter { $0 >= 0 }
            .withUnretained(self)
            .subscribe { owner, time in
                let timerText = owner.secToTime(sec: time)
                owner.output.timerLabelText.accept(timerText)
            }
            .disposed(by: disposeBag)
        
        let validationNumberText = input.validationNumberText
            .share()
        
        validationNumberText
            .map { $0.count >= 6 }
            .bind(to: output.isButtonEnable)
            .disposed(by: disposeBag)
        
        validationNumberText
            .withUnretained(self)
            .map { owner, text in
                owner.restrictTextCount(text: text)
            }
            .bind(to: output.textFieldText)
            .disposed(by: disposeBag)
        
        input.tapReRequestButton
            .withUnretained(self)
            .bind(onNext: { (owner, _) in
                FirebaseAuthService.shared.requestVerificationCode(phoneNumber: UserInfo.phoneNumber)
                    .asDriver { error in
                        let errorMessage = FirebaseAuthService.shared.authErrorHandler(error: error)
                        owner.output.errorMessage.accept(errorMessage)
                        return Driver.just(())
                    }
                    .drive(onNext: { _ in
                        owner.output.errorMessage.accept("인증번호를 보냈습니다.")
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.tapCheckValidationButton
            .withLatestFrom(output.textFieldText)
            .withUnretained(self)
            .bind(onNext: { (owner, text) in
                // MARK: 여기서 인증코드 입력했을 때 코드 작성
                if text.count == 6 && Int(text) != nil {
                    // 번호로 가입되어 있다면
                    // 가입되어 있지 않다면
                    FirebaseAuthService.shared.userVerificaiton(verificaitonCode: text)
                        .asDriver { error in
                            let errorMessage = FirebaseAuthService.shared.authErrorHandler(error: error)
                            owner.output.errorMessage.accept(errorMessage)
                            return Driver.just("")
                        }
                        .drive { idToken in
                            UserInfo.idToken = idToken
                            APIService.shared.getUser(idToken: idToken)
                        }
                        .disposed(by: owner.disposeBag)
                    
//                    owner.output.goToNicknameView.accept(())
                    
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
        let verificationID = UserInfo.verificationID
        print(verificationID)
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificaitonCode
        )

        Auth.auth().signIn(with: credential) { [weak self](result, error) in
            guard let self = self else { return }
            if let error = error {
                let authError = error as NSError
                print(authError.code)
                print(error.localizedDescription)
                self.output.errorMessage.accept(error.localizedDescription)
            }
            if let result = result {
                print(result)
            }
        }
    }
    
    init() {
        transForm()
    }
    
    deinit {
        print("===LoginViewModel Deinit===")
    }
    
}
