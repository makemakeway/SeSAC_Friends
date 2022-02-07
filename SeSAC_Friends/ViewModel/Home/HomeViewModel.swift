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
        let entireButtonClicked = PublishSubject<Void>()
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
    }
    
    var disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    
    func transform() {
        input.entireButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.entireButtonState.accept(.fill)
                owner.output.manButtonState.accept(.disable)
                owner.output.womanButtonState.accept(.disable)
            }
            .disposed(by: disposeBag)
        
        input.manButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.entireButtonState.accept(.disable)
                owner.output.manButtonState.accept(.fill)
                owner.output.womanButtonState.accept(.disable)
            }
            .disposed(by: disposeBag)

        input.womanButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.entireButtonState.accept(.disable)
                owner.output.manButtonState.accept(.disable)
                owner.output.womanButtonState.accept(.fill)
            }
            .disposed(by: disposeBag)

        input.mapViewCameraDidChanged
            .withUnretained(self)
            .flatMap { owner, position in
                owner.fetchFriends(position: position)
            }
            .bind { friends in
                print("Friend Fetched: \(friends)")
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
        
        
        let grid = (Int(gridX) ?? 0) + (Int(gridY) ?? 0)
        return grid
    }
    
    init() {
        
    }
}
