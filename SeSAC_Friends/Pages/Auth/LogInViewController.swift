//
//  LogInViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/20.
//

import UIKit
import RxCocoa
import RxSwift
import Toast

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
        
        mainView.authInputView.reRequestButton.rx.tap
            .asDriver()
            .drive(viewModel.input.tapReRequestButton, viewModel.input.timerStart)
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldText
            .withUnretained(self)
            .bind(onNext: { owner, text in
                owner.mainView.authInputView.textField.text = text
            })
            .disposed(by: disposeBag)
    
        viewModel.output.isButtonEnable
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, bool in
                if bool {
                    owner.mainView.authRequestButton.buttonState = .fill
                } else {
                    owner.mainView.authRequestButton.buttonState = .disable
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, errorText in
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
        
        viewModel.output.timerLabelText
            .asDriver()
            .drive(with: self) { owner, text in
                owner.mainView.authInputView.timerLabel.text = text
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
        self.view.makeToast("인증 번호를 보냈습니다.")
        
        viewModel.input.timerStart.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("===LoginView Controller Deinit===")
    }
}
