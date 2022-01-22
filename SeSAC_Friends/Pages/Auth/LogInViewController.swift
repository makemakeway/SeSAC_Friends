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
            .bind(onNext: { [weak self](text) in
                guard let self = self else { return }
                self.mainView.authInputView.textField.text = text
            })
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
                self.mainView.authInputView.textFieldState = state
            })
            .disposed(by: disposeBag)
            
        viewModel.output.goToNicknameView
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                let vc = NickNameViewController()
                print("push Nickname")
                self.navigationController?.pushViewController(vc, animated: true)
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
