//
//  GenderViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/29.
//

import Foundation
import RxSwift
import RxRelay

class GenderViewModel: ViewModelType {
    struct Input {
        let confirmButtonClicked = PublishSubject<Void>()
        let manButtonClicked = PublishSubject<Void>()
        let womanButtonClicked = PublishSubject<Void>()
    }
    
    struct Output {
        let manButtonState = BehaviorRelay(value: false)
        let womanButtonState = BehaviorRelay(value: false)
        let errorMessage = PublishRelay<String>()
        let goToHome = PublishRelay<Void>()
        let goToNickName = PublishRelay<Void>()
        let isButtonEnable = BehaviorRelay(value: false)
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    
    var manButtonFocused = false
    var womanButtonFocused = false
    
    func transform() {
        input.manButtonClicked
            .debug()
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                if owner.manButtonFocused {
                    owner.output.manButtonState.accept(false)
                    UserInfo.gender = -1
                } else {
                    UserInfo.gender = 1
                    owner.output.manButtonState.accept(true)
                    owner.output.womanButtonState.accept(false)
                }
                owner.manButtonFocused.toggle()
                owner.womanButtonFocused = false
            }
            .disposed(by: disposeBag)
            
        
        input.womanButtonClicked
            .debug()
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                if owner.womanButtonFocused {
                    owner.output.womanButtonState.accept(false)
                    UserInfo.gender = -1
                } else {
                    UserInfo.gender = 0
                    owner.output.womanButtonState.accept(true)
                    owner.output.manButtonState.accept(false)
                }
                owner.womanButtonFocused.toggle()
                owner.manButtonFocused = false
            }
            .disposed(by: disposeBag)
        
        
        Observable
            .combineLatest(output.womanButtonState, output.manButtonState)
            .asDriver(onErrorJustReturn: (false, false))
            .drive(with: self) { (owner, arg1) in
                let (woman, man) = arg1
                if woman || man {
                    owner.output.isButtonEnable.accept(true)
                } else {
                    owner.output.isButtonEnable.accept(false)
                }
            }
            .disposed(by: disposeBag)

        input.confirmButtonClicked
            .subscribe { _ in
                self.output.goToHome.accept(())
            }
            .disposed(by: disposeBag)

    }
    
    init() {
        transform()
    }
}
