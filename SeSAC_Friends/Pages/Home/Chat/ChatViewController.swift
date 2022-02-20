//
//  ChatViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxKeyboard

final class ChatViewController: UIViewController {
    //MARK: Properties
    
    private var disposeBag = DisposeBag()
    
    //MARK: UI
    
    private let mainView = ChatView()
    
    //MARK: Method
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            let viewControllers = self.navigationController!.viewControllers
            if ((viewControllers[viewControllers.count - 2]).isKind(of: HomeViewController.self)) {
                (viewControllers[viewControllers.count - 2] as! HomeViewController).hidesBottomBarWhenPushed = false
            }
        }
    }
    
    private func bind() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(with: self) { owner, height in
                UIView.animate(withDuration: 0.1) {
                    owner.mainView.chatTextView.snp.updateConstraints { make in
                        make.bottom.equalTo(owner.mainView.safeAreaLayoutGuide).offset(-height)
                    }
                }
                owner.mainView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        mainView.chatTextView.textView.rx.didEndEditing
            .asDriver()
            .drive(with: self) { owner, _ in
                UIView.animate(withDuration: 0.1) {
                    owner.mainView.chatTextView.snp.updateConstraints { make in
                        make.bottom.equalTo(owner.mainView.safeAreaLayoutGuide).offset(-16)
                    }
                }
                owner.mainView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        mainView.chatTextView.textView.rx.text.orEmpty
            .bind(with: self) { owner, text in
                let textView = owner.mainView.chatTextView
                text.isEmpty == true ? (textView.placeholerLabel.isHidden = false) : (textView.placeholerLabel.isHidden = true)
                
                DispatchQueue.main.async {
                    let height = textView.textView.contentSize.height
                    if height <= 80 {
                        textView.textView.snp.updateConstraints { make in
                            make.height.equalTo(height)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    //MARK: LifeCycle
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채팅"
        mainView.backgroundColor = .systemBackground
        bind()
    }
}
