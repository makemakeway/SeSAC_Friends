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
        
        mainView.inputTextField.textField.rx.text.orEmpty
            .bind(to: viewModel.input.textFieldText)
            .disposed(by: disposeBag)
        
        mainView.inputTextField.textField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.tapPhoneNumberTextField)
            .disposed(by: disposeBag)
        
        mainView.inputTextField.textField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                guard let self = self else { return }
                guard let text = self.mainView.inputTextField.textField.text, text.isEmpty else {
                    return
                }
                self.mainView.inputTextField.textFieldState = .active
            }
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
        
        viewModel.output.goToLoginView
            .observe(on: MainScheduler.instance)
            .bind(onNext: pushToLoginViewController)
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
                self.mainView.inputTextField.textFieldState = state
            })
            .disposed(by: disposeBag)
        
        viewModel.output.phoneNumberText
            .observe(on: MainScheduler.instance)
            .bind { [weak self](text) in
                guard let self = self else { return }
                self.mainView.inputTextField.textField.text = text
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

