//
//  EnterHobbyViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/12.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class EnterHobbyViewModel: ViewModelType {
    struct Input {
        let willAppear = PublishSubject<Void>()
        let searchSesacButtonClicked = PublishSubject<Void>()
        let errorOccurred = PublishSubject<APIError>()
        let cellItemClicked = PublishSubject<(IndexPath, String)>()
    }
    
    struct Output {
        let nowAround:BehaviorRelay<[UserHobbySection]> = BehaviorRelay(value: [])
        let goToNearUser = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        let goToOnboarding = PublishRelay<Void>()
        let activating = PublishRelay<Bool>()
        let clickedCellItem = BehaviorRelay(value: "")
    }
    
    let input = Input()
    let output = Output()
    
    var disposeBag = DisposeBag()
    
    func transfrom() {
        let hobbies = input.willAppear
            .withUnretained(self)
            .do(onNext: { owner, _ in owner.output.activating.accept(true) })
            .flatMap { owner, _ in owner.fetchFriends(position: UserInfo.userPosition) }
            .share()
        
        hobbies
            .withUnretained(self)
            .map { (owner, friends) -> [UserHobbySection] in
                var otherUsersHobbies: Set<Hobbies> = []
                var serverHobbies: Array<Hobbies> = []
                
                friends.fromRecommend.forEach {
                    serverHobbies.append(Hobbies(hobby: $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), type: .fromServer))
                }
                
                for friend in friends.fromQueueDBRequested {
                    friend.hf.forEach {
                        otherUsersHobbies.insert(Hobbies(hobby: $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), type: .fromUser))
                    }
                }
                
                for friend in friends.fromQueueDB {
                    friend.hf.forEach {
                        otherUsersHobbies.insert(Hobbies(hobby: $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), type: .fromUser))
                    }
                }
                
                let items = serverHobbies + Array(otherUsersHobbies)
                
                return [UserHobbySection(header: "지금 주변에는", items: items),
                        UserHobbySection(header: "내가 하고 싶은", items: [])]
            }
            .do(onNext: { [weak self]_ in self?.output.activating.accept(false) })
            .bind(with: self) { owner, section in
                owner.output.nowAround.accept(section)
            }
            .disposed(by: disposeBag)
        
        input.searchSesacButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.output.goToNearUser.accept(())
            }
            .disposed(by: disposeBag)
        
        input.cellItemClicked
            .debug("cell clicked")
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, args1 in
                let (indexPath, hobby) = args1
                if indexPath.section == 0 {
                    owner.appendLogic(sections: owner.output.nowAround.value, new: hobby)
                } else {
                    owner.removeLogic(sections: owner.output.nowAround.value, at: indexPath)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func appendLogic(sections: [UserHobbySection], new hobby: String) {
        var currentSections = sections
        let newSectionItem = Hobbies(hobby: hobby, type: .userSelected)
        if currentSections[1].items.contains(newSectionItem) {
            output.errorMessage.accept("이미 등록된 취미입니다.")
        } else {
            if currentSections[1].items.count >= 8 {
                output.errorMessage.accept("취미를 더 이상 추가할 수 없습니다")
            } else {
                currentSections[1].items.append(newSectionItem)
                output.nowAround.accept(currentSections)
            }
        }
    }
    
    func removeLogic(sections: [UserHobbySection], at indexPath: IndexPath) {
        var currentSections = sections
        currentSections[1].items.remove(at: indexPath.row)
        output.nowAround.accept(currentSections)
    }
    
    
    func fetchFriends(position: (Double, Double)) -> Observable<Friends> {
        return APIService.shared.fetchFriends(region: locationToRegion(position: position),
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
    
    func locationToRegion(position: (Double, Double)) -> Int {
        let x = "\((position.0 + 90) * 10000)"
        let targetX = x.index(x.startIndex, offsetBy: 4)
        let gridX = x[x.startIndex...targetX]
        
        let y = "\((position.1 + 180) * 10000)"
        let targetY = y.index(y.startIndex, offsetBy: 4)
        let gridY = y[y.startIndex...targetY]
        
        let stringGrid = "\(gridX)\(gridY)"
        let grid = Int(stringGrid) ?? 0
        return grid
    }
    
    init() {
        transfrom()
    }
}
