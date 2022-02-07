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
import NMapsMap

final class HomeViewModel: ViewModelType {
    struct Input {
        let entireButtonClicked = BehaviorSubject(value: ())
        let manButtonClicked = PublishSubject<Void>()
        let womanButtonClicked = PublishSubject<Void>()
        let locationDidChanged = PublishSubject<CLLocationCoordinate2D>()
        let mapViewCameraDidChanged = PublishSubject<NMFCameraPosition>()
    }
    
    struct Output {
        let entireButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .fill)
        let manButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .disable)
        let womanButtonState: BehaviorRelay<ButtonState> = BehaviorRelay(value: .disable)
        let currentLocation: BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734))
        let currentMapViewCamera: BehaviorRelay<NMFCameraPosition> = BehaviorRelay(value: NMFCameraPosition())
        let errorMessage = PublishRelay<String>()
        let goToOnboarding = PublishRelay<Void>()
        let friendsList = PublishRelay<Friends>()
        let filteredQueueList = PublishRelay<[FromQueueDB]>()
        let filteredRequiredQueueList = PublishRelay<[FromQueueDB]>()
        let currentFilterValue = BehaviorRelay(value: -1)
    }
    
    var disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    

    
    func transform() {
        let friendsList = output.friendsList
            .share()
            .debug("friendsList")
        
        input.entireButtonClicked
            .debug("entireButtonClicked")
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
            .debug("manButtonClicked")
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
            .debug("womanButtonClicked")
            .withUnretained(self)
            .filter { owner, _ in owner.output.currentFilterValue.value != 0 }
            .bind(with: self) { owner, friends in
                owner.output.entireButtonState.accept(.disable)
                owner.output.manButtonState.accept(.disable)
                owner.output.womanButtonState.accept(.fill)
                
                owner.output.currentFilterValue.accept(0)
            }
            .disposed(by: disposeBag)

        input.mapViewCameraDidChanged
            .debug("mapViewCameraDidChanged")
            .withUnretained(self)
            .flatMap { owner, position in
                owner.fetchFriends(position: position)
            }
            .bind(with: self) { owner, friends in
                owner.output.friendsList.accept(friends)
            }
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(friendsList, output.currentFilterValue)
            .debug("COMBINE")
            .asObservable()
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

    }
        
    func fetchFriends(position: NMFCameraPosition) -> Observable<Friends> {
        print(position.target)
        
        return APIService.shared.fetchFriends(region: self.locationToRegion(location: position),
                                       lat: position.target.lat,
                                       long: position.target.lng)
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
    
    func locationToRegion(location: NMFCameraPosition) -> Int {
        let x = "\((location.target.lat + 90) * 10000)"
        let targetX = x.index(x.startIndex, offsetBy: 4)
        let gridX = x[x.startIndex...targetX]
        
        let y = "\((location.target.lng + 180) * 10000)"
        let targetY = y.index(y.startIndex, offsetBy: 4)
        let gridY = y[y.startIndex...targetY]
        
        let stringGrid = "\(gridX)\(gridY)"
        print(stringGrid)
        let grid = Int(stringGrid) ?? 0
        return grid
    }
    
    init() {
        
    }
}
