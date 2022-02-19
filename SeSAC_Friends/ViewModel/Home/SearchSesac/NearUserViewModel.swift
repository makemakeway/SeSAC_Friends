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
        let requestButtonClicked = PublishSubject<String>()
        let acceptButtonClicked = PublishSubject<String>()
        let willAppear = PublishSubject<Void>()
        let refreshButtonClicked = PublishSubject<Void>()
        let refreshControlValueChanged = PublishSubject<Void>()
        let cardViewClosed = PublishSubject<Void>()
        let timerStarted = PublishSubject<Int>()
        let stopSearchButtonClicked = PublishSubject<Void>()
        let fetchUserQueueState = PublishSubject<Int>()
        let acceptHobby = PublishSubject<Void>()
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let goToOnboarding = PublishRelay<Void>()
        let nearUsers = PublishRelay<[FromQueueDB]>()
        let requestedUsers = PublishRelay<[FromQueueDB]>()
        let activating = PublishRelay<Bool>()
        let refreshLoading = PublishRelay<Bool>()
        let currentUserState = PublishRelay<UserMatchingState>()
        let matchedOtherUser = PublishRelay<Void>()
        let tooLongWaited = PublishRelay<Void>()
        let stopSearch = PublishRelay<Void>()
        let goToChat = PublishRelay<Void>()
    }
    
    let input = Input()
    let output = Output()
    
    func transform() {
        
        input.requestButtonClicked
            .do(onNext: { [weak self] _ in self?.output.activating.accept(true) })
            .withUnretained(self)
            .flatMap { owner, uid in owner.hobbyRequest(uid: uid) }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.output.activating.accept(false) })
            .bind(with: self) { owner, status in
                switch status {
                case 200:
                    owner.output.errorMessage.accept("취미 함께 하기 요청을 보냈습니다")
                case 201:
                    owner.input.acceptHobby.onNext(())
                    owner.output.errorMessage.accept("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다.")
                default:
                    owner.output.errorMessage.accept("상대방이 취미 함께 하기를 그만두었습니다")
                }
            }
            .disposed(by: disposeBag)
        
        let acceptHobby =  input.acceptHobby
            .withLatestFrom(input.requestButtonClicked)
            .share()
        
        Observable.merge(input.acceptButtonClicked, acceptHobby)
            .do(onNext: { [weak self] _ in self?.output.activating.accept(true) })
            .withUnretained(self)
            .flatMap { owner, uid in owner.hobbyAccept(uid: uid) }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.output.activating.accept(false) })
            .bind(with: self) { owner, status in
                switch status {
                case 200:
                    UserInfo.userState = .matched
                    owner.output.goToChat.accept(())
                case 201:
                    owner.output.errorMessage.accept("상대방이 이미 다른 사람과 취미를 함께 하는 중입니다")
                case 202:
                    owner.output.errorMessage.accept("상대방이 취미 함께 하기를 그만두었습니다")
                default:
                    owner.output.errorMessage.accept("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")
                    owner.input.fetchUserQueueState.onNext(0)
                }
            }
            .disposed(by: disposeBag)
                
            
        
        input.stopSearchButtonClicked
            .withUnretained(self)
            .do(onNext: { [weak self] _ in self?.output.activating.accept(true) })
            .flatMap { owner, _ in owner.stopSearch() }
            .do(onNext: { [weak self] _ in self?.output.activating.accept(false) })
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, status in
                print(status)
                switch status {
                case 200:
                    UserInfo.userState = .normal
                    owner.output.stopSearch.accept(())
                case 201:
                    owner.output.matchedOtherUser.accept(())
                default:
                    owner.output.errorMessage.accept("에러가 발생했습니다.")
                }
            }
            .disposed(by: disposeBag)

        
        Observable.merge(input.timerStarted, input.fetchUserQueueState)
            .debug("유저 상태 불러오기")
            .withUnretained(self)
            .flatMap { owner, _ in owner.fetchUserState() }
            .bind(with: self) { owner, userState in
                print("CURRENT: \(userState)")
                if userState.matched == 1 && UserInfo.userState != .matched {
                    owner.output.matchedOtherUser.accept(())
                    owner.output.errorMessage.accept("\(userState.matchedNick ?? "")님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다")
                    UserInfo.userState = .matched
                }
            }
            .disposed(by: disposeBag)

        Observable.merge(input.willAppear, input.cardViewClosed, input.refreshButtonClicked, input.refreshControlValueChanged)
            .debug("Merge")
            .do(onNext: { [weak self]_ in self?.output.activating.accept(true) })
            .throttle(.seconds(5), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
                .flatMap { owner, _ in owner.fetchFriends(position: (UserInfo.mapPosition.lat, UserInfo.mapPosition.lng)) }
            .do(onNext: { [weak self]_ in self?.output.activating.accept(false) })
            .bind(with: self) { owner, friends in
                owner.output.nearUsers.accept(friends.fromQueueDB)
                owner.output.requestedUsers.accept(friends.fromQueueDBRequested)
                owner.output.refreshLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    private func hobbyRequest(uid: String) -> Observable<Int> {
        return APIService.shared.hobbyRequest(uid: uid)
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
            .retry { error in
                error.filter { error in
                    if let error = error as? APIError, error == .tokenExpired {
                        return true
                    }
                    return false
                }
                .take(2)
                .flatMap { _ -> Single<String> in FirebaseAuthService.shared.getIdToken().debug("REFresh IDTOKEN") }
            }
            .asObservable()
    }
    
    private func hobbyAccept(uid: String) -> Observable<Int> {
        return APIService.shared.hobbyAccept(uid: uid)
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
            .retry { error in
                error.filter { error in
                    if let error = error as? APIError, error == .tokenExpired {
                        return true
                    }
                    return false
                }
                .take(2)
                .flatMap { _ -> Single<String> in FirebaseAuthService.shared.getIdToken().debug("REFresh IDTOKEN") }
            }
            .asObservable()
    }
    
    
    private func stopSearch() -> Observable<Int> {
        return APIService.shared.stopSearchSesac()
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
            .retry { error in
                error.filter { error in
                    if let error = error as? APIError, error == .tokenExpired {
                        return true
                    }
                    return false
                }
                .take(2)
                .flatMap { _ -> Single<String> in FirebaseAuthService.shared.getIdToken().debug("REFresh IDTOKEN") }
            }
            .asObservable()
    }
    
    private func fetchFriends(position: (Double, Double)) -> Observable<Friends> {
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
                .take(2)
                .flatMap { _ -> Single<String> in FirebaseAuthService.shared.getIdToken().debug("REFresh IDTOKEN") }
            }
            .asObservable()
    }
    
    private func locationToRegion(location: (Double, Double)) -> Int {
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
    
    private func fetchUserState() -> Observable<UserMatchingState> {
        return APIService.shared.getMyQueueState()
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
                    case .tooLongWating:
                        self?.output.errorMessage.accept(APIError.tooLongWating.rawValue)
                        self?.output.tooLongWaited.accept(())
                        UserInfo.userState = .normal
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
                .take(2)
                .flatMap { _ -> Single<String> in FirebaseAuthService.shared.getIdToken().debug("REFresh IDTOKEN") }
            }
            .asObservable()
    }
    
    init() {
        transform()
    }
}
