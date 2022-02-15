//
//  NearUserViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/15.
//

import Foundation
import RxSwift
import RxRelay

final class NearUserViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let requestButtonClicked = PublishSubject<Void>()
        let cellClicked = PublishSubject<Void>()
    }
    
    struct Output {
        let requestNearSesac: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let openOrClose: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    func transform() {
        input.cellClicked
            .withLatestFrom(output.openOrClose)
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, opened in
                if opened {
                    owner.output.openOrClose.accept(false)
                } else {
                    owner.output.openOrClose.accept(true)
                }
            }
            .disposed(by: disposeBag)

    }
    
    init() {
        transform()
    }
}
