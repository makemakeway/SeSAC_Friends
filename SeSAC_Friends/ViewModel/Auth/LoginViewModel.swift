//
//  LoginViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/20.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let validationNumberText = PublishSubject<String>()
        let tapCheckValidationButton = PublishSubject<Void>()
        let tapValidationNumberTextField = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let goToLoginView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
    }
    
    var input = Input()
    var output = Output()
    
    func transForm() {
        input.validationNumberText
            .asObservable()
            .map { $0.count > 5 }
            .bind(to: output.isButtonEnable)
            .disposed(by: disposeBag)
        
        input.tapCheckValidationButton.withLatestFrom(input.validationNumberText)
            .bind { [weak self](text) in
                guard let self = self else { return }
                // MARK: 여기서 인증코드 입력했을 때 코드 작성
                if text.count == 6 && Int(text) != nil {
                    
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
    
    init() {
        transForm()
    }
    
}
