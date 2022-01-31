//
//  BirthViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/26.
//

import Foundation
import RxSwift
import RxRelay

final class BirthViewModel: ViewModelType {
    struct Input {
        let tapConfirmButton = PublishSubject<Void>()
        let selectedDate = PublishSubject<Date>()
        let valueChanged = PublishSubject<Void>()
    }
    
    struct Output {
        let isButtonEnable = BehaviorRelay(value: false)
        let goToEmailView = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let yearText = PublishRelay<String>()
        let monthText = PublishRelay<String>()
        let dayText = PublishRelay<String>()
    }
    
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var birthDay: Date?
    
    func transform() {
        let selectedDate = input.selectedDate
            .share()
        
        input.valueChanged
            .take(1)
            .map { true }
            .asDriver(onErrorJustReturn: false)
            .drive(output.isButtonEnable)
            .disposed(by: disposeBag)

        input.tapConfirmButton
            .withLatestFrom(output.isButtonEnable)
            .filter { $0 == true }
            .withLatestFrom(selectedDate)
            .map { [weak self] in self?.checkUserAge(date: $0) }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, valid in
                if valid! {
                    if Connectivity.isConnectedToInternet {
                        UserInfo.birthday = DateManager.shared.dateToString(date: owner.birthDay!)
                        owner.output.goToEmailView.accept(())
                    } else {
                        owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                    }
                } else {
                    owner.output.errorMessage.accept("새싹친구는 만 17세 이상만 사용할 수 있습니다.")
                }
            }
            .disposed(by: disposeBag)

        selectedDate
            .map { [weak self] in self?.dateToString(date: $0) }
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, components in
                guard let components = components else { return }
                owner.output.yearText.accept(components[0])
                owner.output.monthText.accept(components[1])
                owner.output.dayText.accept(components[2])
            }
            .disposed(by: disposeBag)

        selectedDate
            .bind(with: self) { owner, date in
                owner.birthDay = date
            }
            .disposed(by: disposeBag)
            
    }
    
    func checkUserAge(date: Date) -> Bool {
        let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let birth = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        let age = Calendar.current.dateComponents([.year, .month, .day], from: birth, to: now)
        print(age)
        if age.year! >= 17 {
            return true
        } else if age.month! > 0 {
            return false
        } else if age.day! > 0 {
            return false
        }
        return true
    }
    
    func dateToString(date: Date) -> [String] {
        var birth = Calendar.current.dateComponents([.year, .month, .day], from: date)
        birth.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        return ["\(birth.year!)", "\(birth.month!)", "\(birth.day!)"]
    }
    
    init() {
        transform()
    }
}
