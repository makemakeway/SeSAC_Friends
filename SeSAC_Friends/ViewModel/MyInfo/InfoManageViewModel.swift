//
//  MyInfoViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class InfoManageViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    struct Input {
        let saveButtonClicked = PublishSubject<Void>()
        let manButtonClicked = PublishSubject<Void>()
        let womanButtonClicked = PublishSubject<Void>()
        let tapHobbyTextField = PublishSubject<Void>()
        let endEditTextField = PublishSubject<Void>()
        let allowSearchPhoneNumber = PublishSubject<Bool>()
        let tapWithdrawView = PublishSubject<UITapGestureRecognizer>()
        let infoManageViewWillAppear = BehaviorRelay(value: ())
        let tapNicknameView = PublishSubject<UITapGestureRecognizer>()
        let ageValueChanged = PublishRelay<[CGFloat]>()
        let hobbyTextFieldText = BehaviorRelay(value: "")
        let withdrawButtonClicked = PublishSubject<Void>()
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let switchValue = BehaviorRelay(value: false)
        let ageValue: BehaviorRelay<[CGFloat]> = BehaviorRelay(value: [])
        let textFieldText = BehaviorRelay(value: "")
        let manButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .inactive)
        let womanButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .inactive)
        let goToOnboarding = PublishRelay<Void>()
        let goToPrevious = PublishRelay<Void>()
        let floatingPopUp = PublishRelay<Void>()
        let sesacTitles: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let sesacReviews: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        let backgroundImage = BehaviorRelay(value: 0)
        let sesacImage = BehaviorRelay(value: 0)
        let genderValue = BehaviorRelay(value: -1)
        let openOrClose = PublishRelay<Bool>()
        let textFieldState: BehaviorRelay<TextFieldState> = BehaviorRelay(value: .inActive)
    }
    
    let input = Input()
    let output = Output()
    
    var opened = false
    var userDataFetched = false
    
    func transform() {
        input.saveButtonClicked
            .withUnretained(self)
            .flatMap { owner, _ in
                APIService.shared.updateMypage(searchable: owner.output.switchValue.value ? 1 : 0,
                                               ageMin: Int(owner.output.ageValue.value[0]),
                                               ageMax: Int(owner.output.ageValue.value[1]),
                                               gender: owner.output.genderValue.value,
                                               hobby: owner.output.textFieldText.value)
                    .catch { error in
                        if let error = error as? APIError {
                            print(error)
                            switch error {
                            case .unKnownedUser:
                                owner.output.goToOnboarding.accept(())
                            case .disConnect:
                                owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                            default:
                                print("그 외 에러")
                            }
                        }
                        return .just(0)
                    }
            }
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, status in
                switch status {
                case 200:
                    owner.output.goToPrevious.accept(())
                default:
                    print("그 외 에러")
                }
            }
            .disposed(by: disposeBag)

        input.withdrawButtonClicked
            .withUnretained(self)
            .flatMap { owner, _ in
                APIService.shared.withdraw()
                    .catch { error in
                        if let error = error as? APIError {
                            switch error {
                            case .tokenExpired:
                                print("토큰 만료")
                            case .unKnownedUser:
                                owner.output.goToOnboarding.accept(())
                            case .disConnect:
                                owner.output.errorMessage.accept(APIError.disConnect.rawValue)
                            default:
                                print("회원 탈퇴 에러")
                            }
                        }
                        return .just(0)
                    }
            }
            .asDriver(onErrorJustReturn: 0)
            .filter { $0 == 200 }
            .drive(with: self) { owner, status in
                owner.output.goToOnboarding.accept(())
            }
            .disposed(by: disposeBag)

        
        input.hobbyTextFieldText
            .asDriver()
            .drive(output.textFieldText)
            .disposed(by: disposeBag)
        
        input.tapWithdrawView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.output.floatingPopUp.accept(())
            })
            .disposed(by: disposeBag)
        
        input.infoManageViewWillAppear
            .debug("UserData")
            .flatMap { APIService.shared.getUserData(idToken: UserInfo.idToken) }
            .bind(with: self, onNext: { owner, user in
                owner.userDataFetched = true
                let ageMin = CGFloat(user.ageMin)
                let ageMax = CGFloat(user.ageMax)
                owner.output.ageValue.accept([ageMin, ageMax])
                owner.output.switchValue.accept(user.searchable == 1)
                owner.output.textFieldText.accept(user.hobby)
                owner.output.sesacTitles.accept(user.reputation)
                owner.output.sesacReviews.accept(user.comment)
                owner.output.backgroundImage.accept(user.background)
                owner.output.sesacImage.accept(user.sesac)
                owner.output.genderValue.accept(user.gender)
                if user.gender == 1 {
                    owner.output.manButtonState.accept(.fill)
                } else if user.gender == 0 {
                    owner.output.womanButtonState.accept(.fill)
                }
            })
            .disposed(by: disposeBag)
        
        input.tapNicknameView
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                owner.opened.toggle()
                owner.output.openOrClose.accept(owner.opened)
            })
            .disposed(by: disposeBag)
            
        input.manButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.manButtonState.accept(.fill)
                owner.output.womanButtonState.accept(.inactive)
                owner.output.genderValue.accept(1)
            }
            .disposed(by: disposeBag)

        input.womanButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.womanButtonState.accept(.fill)
                owner.output.manButtonState.accept(.inactive)
                owner.output.genderValue.accept(0)
            }
            .disposed(by: disposeBag)
        
        input.ageValueChanged
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, values in
                owner.output.ageValue.accept(values)
            }
            .disposed(by: disposeBag)

        input.tapHobbyTextField
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.textFieldState.accept(.focus)
            }
            .disposed(by: disposeBag)

        input.endEditTextField
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.textFieldState.accept(.active)
            }
            .disposed(by: disposeBag)
        
        input.allowSearchPhoneNumber
            .asDriver(onErrorJustReturn: false)
            .drive(output.switchValue)
            .disposed(by: disposeBag)
        
    }
    
    init() {
        transform()
    }
}
