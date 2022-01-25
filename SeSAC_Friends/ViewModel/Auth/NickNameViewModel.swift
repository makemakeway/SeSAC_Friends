//
//  NickNameViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/25.
//

import Foundation
import RxSwift
import RxRelay

class NickNameViewModel: ViewModelType {
    struct Input {
        let textFieldText = PublishSubject<String>()
        let tapConfirmButton = PublishSubject<Void>()
        let tapTextField = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
        let goToLoginView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let phoneNumberText = PublishRelay<String>()
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transForm() {
        
    }
    
    init() {
        transForm()
    }
}
