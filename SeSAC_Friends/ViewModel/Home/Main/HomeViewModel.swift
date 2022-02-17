//
//  HomeViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/07.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation

final class HomeViewModel: ViewModelType {
    struct Input {
        let entireButtonClicked = BehaviorSubject(value: ())
        let manButtonClicked = PublishSubject<Void>()
        let womanButtonClicked = PublishSubject<Void>()
        let locationDidChanged = PublishSubject<CLLocationCoordinate2D>()
        let mapViewCameraDidChanged = PublishSubject<CLLocationCoordinate2D>()
        let locationButtonClicked = PublishSubject<Void>()
        let homeWillAppear = PublishSubject<Void>()
        let userStateChanged = PublishSubject<FloatingButtonState>()
        let currentAuthority = PublishSubject<CLAuthorizationStatus>()
        let floatingButtonClicked = PublishSubject<Void>()
    }
    
    struct Output {
        let entireButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .fill)
        let manButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .disable)
        let womanButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .disable)
        let currentMapViewCamera: BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: DefaultValue.location)
        let errorMessage = PublishRelay<String>()
        let goToOnboarding = PublishRelay<Void>()
        let friendsList = PublishRelay<Friends>()
        let filteredQueueList = PublishRelay<[FromQueueDB]>()
        let filteredRequiredQueueList = PublishRelay<[FromQueueDB]>()
        let currentFilterValue = BehaviorRelay(value: -1)
        let currentUserState = PublishRelay<FloatingButtonState>()
        let currentAuthorization = PublishRelay<CLAuthorizationStatus>()
        let showAlert = PublishRelay<Void>()
        let goToInfoManage = PublishRelay<Void>()
        let goToEnterHobby = PublishRelay<Void>()
        let goToSearchSesac = PublishRelay<Void>()
        let goToChat = PublishRelay<Void>()
    }
    
    var disposeBag = DisposeBag()
    let input = Input()
    let output = Output()

    
    func transform() {
        let friendsList = output.friendsList
            .share()
            .debug("friendsList")
        
        let homeWillAppear = input.homeWillAppear
            .share()
            .debug("홈이 보였다!")
        
        let currentMapViewPosition = input.mapViewCameraDidChanged
            .share()
        
        let currentLocation = input.locationDidChanged
            .share()
        
        homeWillAppear
            .withLatestFrom(input.userStateChanged)
            .debug("홈윌어피어 + 유저스테이트")
            .asDriver(onErrorJustReturn: .normal)
            .drive(with: self) { owner, state in
                owner.output.currentUserState.accept(state)
            }
            .disposed(by: disposeBag)

        let currentUserState = input.userStateChanged
            .share()
        
        let currentUserAuth = homeWillAppear
            .withLatestFrom(input.currentAuthority)
            .withUnretained(self)
            .map { owner, state in owner.checkUserAuthorization(state: state) }
            .asObservable()
            .share()
        
        let floatingButtonClicked = input.floatingButtonClicked
            .withLatestFrom(currentUserState)
            .share()
        
        floatingButtonClicked
            .filter { $0 == .normal }
            .withLatestFrom(currentUserAuth)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, allowed in
                if allowed {
                    // MARK: 토스트 메세지 실험 시 1로 설정할 것
                    if UserInfo.gender == -1 {
                        owner.output.errorMessage.accept("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!")
                        owner.output.goToInfoManage.accept(())
                    } else {
                        owner.output.goToEnterHobby.accept(())
                        let positon = owner.output.currentMapViewCamera.value
                        UserInfo.mapPosition = (positon.latitude, positon.longitude)
                    }
                } else {
                    owner.output.showAlert.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        floatingButtonClicked
            .filter { $0 == .matching }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.output.goToSearchSesac.accept(())
            }
            .disposed(by: disposeBag)
        
        floatingButtonClicked
            .filter { $0 == .matched }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.output.goToChat.accept(())
            }
            .disposed(by: disposeBag)
            
        

        currentUserAuth
            .filter { $0 == false }
            .debug("currentUserAuth: 유저 위치 권한 없음")
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, _ in
                owner.output.currentMapViewCamera.accept(DefaultValue.location)
            }
            .disposed(by: disposeBag)

        currentUserAuth
            .filter { $0 == true }
            .debug("currentUserAuth: 유저 위치 권한 있음")
            .withLatestFrom(currentMapViewPosition)
            .withUnretained(self)
            .flatMap { owner, location in owner.fetchFriends(position: location) }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, friends in
                owner.output.friendsList.accept(friends)
            }
            .disposed(by: disposeBag)
        
        input.entireButtonClicked
            .debug("전체 필터")
            .withUnretained(self)
            .filter { owner, _ in owner.output.currentFilterValue.value != -1 }
            .bind(with: self) { owner, friends in
                owner.output.entireButtonState.accept(.fill)
                owner.output.manButtonState.accept(.disable)
                owner.output.womanButtonState.accept(.disable)
                owner.output.currentFilterValue.accept(-1)
            }
            .disposed(by: disposeBag)
        
        input.manButtonClicked
            .debug("남자 필터")
            .withUnretained(self)
            .filter { owner, _ in owner.output.currentFilterValue.value != 1 }
            .bind(with: self) { owner, friends in
                owner.output.entireButtonState.accept(.disable)
                owner.output.manButtonState.accept(.fill)
                owner.output.womanButtonState.accept(.disable)
                owner.output.currentFilterValue.accept(1)
            }
            .disposed(by: disposeBag)
        
        input.womanButtonClicked
            .debug("여자 필터")
            .withUnretained(self)
            .filter { owner, _ in owner.output.currentFilterValue.value != 0 }
            .bind(with: self) { owner, friends in
                owner.output.entireButtonState.accept(.disable)
                owner.output.manButtonState.accept(.disable)
                owner.output.womanButtonState.accept(.fill)
                
                owner.output.currentFilterValue.accept(0)
            }
            .disposed(by: disposeBag)

        currentMapViewPosition
            .withUnretained(self)
            .distinctUntilChanged { lh, rh in
                (lh.1.latitude == rh.1.latitude) && (lh.1.longitude == rh.1.longitude)
            }
            .debug("맵뷰 카메라 변경")
            .flatMap { owner, position in
                owner.fetchFriends(position: position)
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, friends in
                owner.output.friendsList.accept(friends)
            }
            .disposed(by: disposeBag)
        
        currentLocation
            .asDriver(onErrorJustReturn: DefaultValue.location)
            .drive(with: self) { owner, location in
                owner.output.currentMapViewCamera.accept(location)
                UserInfo.userPosition = (location.latitude, location.longitude)
            }
            .disposed(by: disposeBag)

        
        
        Observable.combineLatest(friendsList, output.currentFilterValue)
            .bind(with: self) { (owner, arg1) in
                let (friends, value) = arg1
                switch value {
                case -1:
                    owner.output.filteredQueueList.accept(friends.fromQueueDB)
                    owner.output.filteredRequiredQueueList.accept(friends.fromQueueDBRequested)
                case 0:
                    let filteredList = friends.fromQueueDB.filter { $0.gender == 0 }
                    let filteredRequiredList = friends.fromQueueDBRequested.filter { $0.gender == 0 }
                    
                    owner.output.filteredQueueList.accept(filteredList)
                    owner.output.filteredRequiredQueueList.accept(filteredRequiredList)
                case 1:
                    let filteredList = friends.fromQueueDB.filter { $0.gender == 1 }
                    let filteredRequiredList = friends.fromQueueDBRequested.filter { $0.gender == 1 }
                    
                    owner.output.filteredQueueList.accept(filteredList)
                    owner.output.filteredRequiredQueueList.accept(filteredRequiredList)
                default:
                    print("필터 에러")
                }
            }
            .disposed(by: disposeBag)
        

        let gpsButtonClickedWithCurrentAuthorization = input.locationButtonClicked
            .debug("GPS 버튼 눌림")
            .withLatestFrom(currentUserAuth)
            .share()
        
        gpsButtonClickedWithCurrentAuthorization
            .debug("위치 권한 있음")
            .filter { $0 == true }
            .withLatestFrom(currentLocation)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, location in
                print("권한 있어서 카메라 위치 현재위치로")
                owner.output.currentMapViewCamera.accept(location)
            }
            .disposed(by: disposeBag)
        
        gpsButtonClickedWithCurrentAuthorization
            .debug("위치 권한 없음")
            .filter { $0 == false }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, status in
                print("권한 없어서 Alert 띄움")
                owner.output.showAlert.accept(())
            }
            .disposed(by: disposeBag)

        currentUserState
            .debug("유저 상태 변경")
            .asDriver(onErrorJustReturn: .normal)
            .drive(with: self) { owner, state in
                owner.output.currentUserState.accept(state)
            }
            .disposed(by: disposeBag)
    }
        
    func fetchFriends(position: CLLocationCoordinate2D) -> Observable<Friends> {
        return APIService.shared.fetchFriends(region: locationToRegion(location: position),
                                       lat: position.latitude,
                                       long: position.longitude)
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
    
    func checkUserAuthorization(state: CLAuthorizationStatus) -> Bool {
        switch state {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
    
    func locationToRegion(location: CLLocationCoordinate2D) -> Int {
        let x = "\((location.latitude + 90) * 10000)"
        let targetX = x.index(x.startIndex, offsetBy: 4)
        let gridX = x[x.startIndex...targetX]
        
        let y = "\((location.longitude + 180) * 10000)"
        let targetY = y.index(y.startIndex, offsetBy: 4)
        let gridY = y[y.startIndex...targetY]
        
        let stringGrid = "\(gridX)\(gridY)"
        let grid = Int(stringGrid) ?? 0
        return grid
    }
    
    init() {
        
    }
}
