//
//  NickNameViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/25.
//

import Foundation
import RxSwift
import RxRelay

final class NickNameViewModel: ViewModelType {
    struct Input {
        let textFieldText = BehaviorSubject(value: UserInfo.nickname)
        let tapConfirmButton = PublishSubject<Void>()
        let tapTextField = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let goToBirthdayView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let textFieldText = BehaviorRelay(value: "")
    }
    
    let input = Input()
    let output = Output()
    var disposeBag: DisposeBag = DisposeBag()
    
    func transForm() {
        let textFieldText = input.textFieldText
            .share()
        
        textFieldText
            .asDriver(onErrorJustReturn: "")
            .drive(output.textFieldText)
            .disposed(by: disposeBag)
        
        let textIsValid = textFieldText
            .map { $0.count >= 1 && $0.count <= 10 }
            .share()
            .debug("validText")
        
        textIsValid
            .asDriver(onErrorJustReturn: false)
            .drive(output.isButtonEnable)
            .disposed(by: disposeBag)

        input.tapConfirmButton
            .withLatestFrom(textIsValid)
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, valid in
                if valid {
                    // 생년월일로
                    UserInfo.nickname = owner.output.textFieldText.value
                    if Connectivity.isConnectedToInternet {
                        owner.output.goToBirthdayView.accept(())
                    } else {
                        owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                    }
                } else {
                    // 에러메세지
                    owner.output.errorMessage.accept("닉네임은 1자 이상 10자 이내로 부탁드려요.")
                }
            }
            .disposed(by: disposeBag)
            
        input.tapTextField
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.textFieldState.accept(.focus)
            }
            .disposed(by: disposeBag)

        textFieldText
            .debug()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, text in
                owner.output.textFieldText.accept(text)
            })
            .disposed(by: disposeBag)
    }
    
    init() {
        transForm()
    }
}
