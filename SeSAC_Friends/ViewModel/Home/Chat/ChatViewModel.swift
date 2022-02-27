//
//  ChatViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RealmSwift

final class ChatViewModel: ViewModelType {
    struct Input {
        let chatText = PublishSubject<String>()
        let viewWillAppear = PublishSubject<Void>()
        
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let goToOnboarding = PublishRelay<Void>()
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let input = Input()
    let output = Output()
    private var userState: UserMatchingState?
    private let localRealm = try! Realm()
    
    func transform() {
        input.chatText
            .withUnretained(self)
            .flatMap { owner, text in
                owner.postChat(to: owner.userState?.matchedUid ?? "", chat: text)
            }
            .bind(with: self) { owner, status in
                switch status {
                case 200:
                    // 응답값 DB에 저장
                    print("응답 성공")
                case 201:
                    owner.output.errorMessage.accept("약속이 종료되어 채팅을 보낼 수 없습니다")
                default:
                    owner.output.errorMessage.accept("잠시 후 다시 시도해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in owner.fetchUserState() }
            .bind(with: self) { owner, state in
                owner.userState = state
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func postChat(to uid: String, chat: String) -> Observable<Int> {
        return APIService.shared.postChat(to: uid, text: chat)
            .catch { [weak self](error) in
                guard let self = self else { return .never() }
                if let error = error as? APIError {
                    self.output.errorMessage.accept(error.rawValue)
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
        
    }
}
