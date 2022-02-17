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
        let willAppear = PublishSubject<Void>()
        let refreshButtonClicked = PublishSubject<Void>()
        let refreshControlValueChanged = PublishSubject<Void>()
        let cardViewClosed = PublishSubject<Void>()
    }
    
    struct Output {
        let requestNearSesac: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let openOrClose: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let errorMessage = PublishRelay<String>()
        let goToOnboarding = PublishRelay<Void>()
        let friendsValue = PublishRelay<[FromQueueDB]>()
        let activating = PublishRelay<Bool>()
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

        Observable.merge(input.willAppear, input.cardViewClosed, input.refreshButtonClicked, input.refreshControlValueChanged)
            .throttle(.seconds(5), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .do(onNext: { owner, _ in owner.output.activating.accept(true) })
            .flatMap { owner, _ in owner.fetchFriends(position: UserInfo.mapPosition) }
            .do(onNext: { [weak self]_ in self?.output.activating.accept(false) })
            .bind(with: self) { owner, friends in
                owner.output.friendsValue.accept(friends.fromQueueDB)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchFriends(position: (Double, Double)) -> Observable<Friends> {
        return APIService.shared.fetchFriends(region: locationToRegion(location: position),
                                       lat: position.0,
                                       long: position.1)
            .catch { [weak self](error) in
                if let error = error as? APIError {
                    switch error {
                    case .tokenExpired:
                        return .error(APIError.tokenExpired)
                    case .serverError:
                        self?.output.errorMessage.accept(APIError.serverError.rawValue)
                    case .unKnownedUser:
                        self?.output.goToOnboarding.accept(())
                    case .disConnect:
                        self?.output.errorMessage.accept(APIError.disConnect.rawValue)
                    default:
                        self?.output.errorMessage.accept(APIError.clientError.rawValue)
                    }
                }
                return .never()
            }
            .retry { (error: Observable<Error>) in
                error.filter { error in
                    if let error = error as? APIError, error == .tokenExpired {
                        return true
                    }
                    return false
                }
                .flatMap { _ -> Single<String> in FirebaseAuthService.shared.getIdToken().debug("REFresh IDTOKEN") }
            }
            .asObservable()
    }
    
    func locationToRegion(location: (Double, Double)) -> Int {
        let x = "\((location.0 + 90) * 10000)"
        let targetX = x.index(x.startIndex, offsetBy: 4)
        let gridX = x[x.startIndex...targetX]
        
        let y = "\((location.1 + 180) * 10000)"
        let targetY = y.index(y.startIndex, offsetBy: 4)
        let gridY = y[y.startIndex...targetY]
        
        let stringGrid = "\(gridX)\(gridY)"
        let grid = Int(stringGrid) ?? 0
        return grid
    }
    
    init() {
        transform()
    }
}
