//
//  EmailViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/27.
//

import UIKit
import RxSwift

class EmailViewController: UIViewController {
    //MARK: Properties
    
    var disposeBag = DisposeBag()
    let viewModel = EmailViewModel()
    
    //MARK: UI
    let mainView = AuthView(state: .email)
    
    //MARK: Method
    private func bind() {
        let textFieldText = mainView.authInputView.textField.rx.text.orEmpty
            .share()
        
        textFieldText
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        mainView.authRequestButton.rx.tap
            .asDriver()
            .drive(viewModel.input.tapConfirmButton)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(viewModel.input.tapTextField)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(textFieldText)
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .drive(with: self) { owner, empty in
                if empty {
                    owner.mainView.authInputView.textFieldState = .inActive
                } else {
                    owner.mainView.authInputView.textFieldState = .active
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.view.makeToast(message)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.goToGenderView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, message in
                let vc = GenderViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnable
            .asDriver()
            .drive(with: self) { owner, enable in
                if enable {
                    owner.mainView.authRequestButton.buttonState = .fill
                } else {
                    owner.mainView.authRequestButton.buttonState = .disable
                }
            }
            .disposed(by: disposeBag)

        viewModel.output.textFieldState
            .asDriver()
            .drive(mainView.authInputView.rx.textFieldState)
            .disposed(by: disposeBag)
    }
    
    //MARK: LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        if !(UserInfo.email.isEmpty) {
            mainView.authInputView.textField.text = UserInfo.email
            viewModel.output.isButtonEnable.accept(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.authInputView.textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
