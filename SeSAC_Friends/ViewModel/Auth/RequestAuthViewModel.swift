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

class RequestAuthViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let input = Input()
    let output = Output()
    
    struct Input {
        let phoneNumberText = PublishSubject<String>()
        let tapAuthRequestButton = PublishSubject<Void>()
        let tapPhoneNumberTextField = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let goToLoginView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
    }
    
    func transForm() {
        input.tapPhoneNumberTextField
            .bind { [weak self](_) in
                guard let self = self else { return }
                self.output.textFieldState.accept(.focus)
            }
            .disposed(by: disposeBag)
        
        input.phoneNumberText
            .asObservable()
            .map { $0.count > 9 }
            .bind(to: output.isButtonEnable)
            .disposed(by: disposeBag)
        
        input.tapAuthRequestButton.withLatestFrom(input.phoneNumberText)
            .bind { [weak self](text) in
                guard let self = self else { return }
                // MARK: 핸드폰 번호 유효성 검사 && Auth 리퀘스트 여기서 구현하면 됨
                if text.count > 9 && Int(text) != nil {
                    self.output.goToLoginView.accept(())
                } else {
                    self.output.errorMessage.accept("올바른 형식의 전화번호를 입력해주세요.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    init() {
        transForm()
    }
}
