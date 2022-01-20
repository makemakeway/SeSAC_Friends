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
        
        mainView.phoneNumberTextField.textField.rx.text.orEmpty
            .bind(to: viewModel.input.validationNumberText)
            .disposed(by: disposeBag)
        
        viewModel.output.isButtonEnable
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self](bool) in
                guard let self = self else { return }
                if bool {
                    self.mainView.authRequestButton.buttonState = .fill
                } else {
                    self.mainView.authRequestButton.buttonState = .disable
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind { [weak self](string) in
                guard let self = self else { return }
                self.view.makeToast(string)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldState
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self](state) in
                guard let self = self else { return }
                self.mainView.phoneNumberTextField.textFieldState = state
            })
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
        mainView.titleLabel.setTextWithLineHeight(text: "인증번호가 문자로 전송되었어요", lineHeight: 32, font: .display1_R20)
        mainView.calloutLabel.text = "(최대 소모 20초)"
        mainView.authRequestButton.buttonState = .disable
        mainView.authRequestButton.setTitle("인증하고 시작하기", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
