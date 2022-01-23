//
//  ViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast

class RequestAuthViewController: UIViewController {
    //MARK: Properties
    let viewModel = RequestAuthViewModel()
    var disposeBag = DisposeBag()
    
    //MARK: UI
    let mainView = AuthView(state: .request)
    
    //MARK: Method
    func bind() {
        mainView.authRequestButton.rx.tap
            .bind(to: viewModel.input.tapAuthRequestButton)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.text.orEmpty
            .bind(to: viewModel.input.textFieldText)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.text.orEmpty
            .bind { text in
                print(text)
            }
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.controlEvent(.editingDidBegin)
            .observe(on: ConcurrentMainScheduler.instance)
            .bind(to: viewModel.input.tapPhoneNumberTextField)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { (owner, _) in
                guard let text = owner.mainView.authInputView.textField.text, text.isEmpty else {
                    return
                }
                owner.mainView.authInputView.textFieldState = .active
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { (owner, bool) in
                if bool {
                    owner.mainView.authRequestButton.buttonState = .fill
                } else {
                    owner.mainView.authRequestButton.buttonState = .disable
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.goToLoginView
            .observe(on: MainScheduler.instance)
            .bind(onNext: pushToLoginViewController)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { (owner, errorText) in
                owner.view.makeToast(errorText)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldState
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { (owner, state) in
                owner.mainView.authInputView.textFieldState = state
            })
            .disposed(by: disposeBag)
        
        viewModel.output.phoneNumberText
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { (owner, text) in
                owner.mainView.authInputView.textField.text = text
            }
            .disposed(by: disposeBag)
    }
    
    func pushToLoginViewController() {
        print("push")
        let vc = LogInViewController()
        self.view.makeToast("인증 번호를 보냈습니다.")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: LifeCycle
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}

