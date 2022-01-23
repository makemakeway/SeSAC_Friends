//
//  LogInViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/20.
//

import UIKit
import RxCocoa
import RxSwift

class LogInViewController: UIViewController {
    //MARK: Properties
    
    var disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    //MARK: UI
    
    let mainView = AuthView(state: .logIn)
    
    //MARK: Method
    func bind() {
        mainView.authRequestButton.rx.tap
            .bind(to: viewModel.input.tapCheckValidationButton)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.tapValidationNumberTextField)
            .disposed(by: disposeBag)
        
        mainView.authInputView.textField.rx.text.orEmpty
            .bind(to: viewModel.input.validationNumberText)
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldText
            .withUnretained(self)
            .bind(onNext: { owner, text in
                owner.mainView.authInputView.textField.text = text
            })
            .disposed(by: disposeBag)
    
        viewModel.output.isButtonEnable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, bool in
                if bool {
                    owner.mainView.authRequestButton.buttonState = .fill
                } else {
                    owner.mainView.authRequestButton.buttonState = .disable
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, errorText in
                owner.view.makeToast(errorText)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldState
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, state in
                owner.mainView.authInputView.textFieldState = state
            })
            .disposed(by: disposeBag)
            
        viewModel.output.goToNicknameView
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let vc = NickNameViewController()
                print("push Nickname")
                owner.navigationController?.pushViewController(vc, animated: true)
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
        bind()
    }
}
