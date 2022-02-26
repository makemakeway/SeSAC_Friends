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

final class ChatViewModel: ViewModelType {
    struct Input {
        let chatText = PublishSubject<String>()
        
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let input = Input()
    let output = Output()
    
    func transform() {
        input.chatText
            .withUnretained(self)
            
        
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
    
    
    init() {
        
    }
}
