//
//  EmailViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/27.
//

import Foundation
import RxSwift
import RxRelay

class EmailViewModel: ViewModelType {
    struct Input {
        let emailText = BehaviorRelay(value: UserInfo.email)
        let tapConfirmButton = PublishSubject<Void>()
        let tapTextField = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let goToGenderView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
    }
    
    var disposeBag = DisposeBag()
    
    let input = Input()
    let output = Output()
    
    func transform() {
        input.tapTextField
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.textFieldState.accept(.focus)
            }
            .disposed(by: disposeBag)

        let emailValidation = input.emailText
            .map { [weak self] in self?.emailIsValid(email: $0) ?? false }
            .share()
        
        emailValidation
            .asDriver(onErrorJustReturn: false)
            .drive(output.isButtonEnable)
            .disposed(by: disposeBag)
        
        input.tapConfirmButton
            .withLatestFrom(emailValidation)
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, valid in
                if valid {
                    if Connectivity.isConnectedToInternet {
                        UserInfo.email = owner.input.emailText.value
                        owner.output.goToGenderView.accept(())
                    } else {
                        owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                    }
                } else {
                    owner.output.errorMessage.accept("이메일 형식이 올바르지 않습니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func emailIsValid(email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) {
            return true
        }
        
        return false
    }
    
    init() {
        transform()
    }
}
