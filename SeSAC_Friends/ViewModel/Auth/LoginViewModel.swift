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

final class LoginViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let validationNumberText = PublishSubject<String>()
        let tapCheckValidationButton = PublishRelay<Void>()
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
            .flatMap { _ in
                FirebaseAuthService.shared.requestVerificationCode(phoneNumber: UserInfo.phoneNumber)
                    .catch { [weak self](error) in
                        guard let error = error as? FirebaseAuthError else { return .just(()) }
                        let errorMessage = FirebaseAuthService.shared.authErrorHandler(error: error)
                        self?.output.errorMessage.accept(errorMessage)
                        return .just(())
                    }
            }
            .bind(with: self) { owner, _ in
                owner.output.errorMessage.accept("인증번호를 보냈습니다.")
            }
            .disposed(by: disposeBag)

        
        let signIn = input.tapCheckValidationButton
            .withLatestFrom(output.textFieldText)
            .filter { $0.count == 6 && Int($0) != nil }
            .flatMap {
                FirebaseAuthService.shared.userVerification(verificationCode: $0)
                    .catch { [weak self](error) in
                        if let error = error as? FirebaseAuthError {
                            let errorMessage = FirebaseAuthService.shared.authErrorHandler(error: error)
                            self?.output.errorMessage.accept(errorMessage)
                        }
                        return .just(false)
                    }
            }
            .asObservable()
            
        let idToken = signIn
            .filter { $0 == true }
            .flatMap { _ in
                FirebaseAuthService.shared.getIdToken()
                    .catch { [weak self](error) in
                        if let error = error as? FirebaseAuthError {
                            let errorMessage = FirebaseAuthService.shared.authErrorHandler(error: error)
                            self?.output.errorMessage.accept(errorMessage)
                        }
                        return .just("")
                    }
            }
            .asObservable()
        
        idToken
            .filter { !($0.isEmpty) }
            .flatMap {
                APIService.shared.getUser(idToken: $0)
                    .catch { [weak self](error) in
                        if let error = error as? APIError {
                            let errorMessage = APIService.shared.apiErrorHandler(error: error)
                            self?.output.errorMessage.accept(errorMessage)
                        }
                        return .just(0)
                    }
            }
            .bind(with: self, onNext: { owner, statusCode in
                switch statusCode {
                case 200: // 가입 유저일 경우, 홈 화면 이동
                    if Connectivity.isConnectedToInternet {
                        UserInfo.signUpCompleted = true
                        owner.output.goToHomeView.accept(())
                    } else {
                        owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                    }
                case 201: // 미가입 유저일 경우, 닉네임 화면 이동
                    if Connectivity.isConnectedToInternet {
                        owner.output.goToNicknameView.accept(())
                    } else {
                        owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                    }
                default:
                    owner.output.errorMessage.accept("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
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
    
    init() {
        transForm()
    }
    
    deinit {
        print("===LoginViewModel Deinit===")
    }
    
}
