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
        
        let textFieldText = viewModel.output.phoneNumberText
            .share()

        mainView.authRequestButton.rx.tap
            .asDriver()
            .drive(viewModel.input.tapAuthRequestButton)
            .disposed(by: disposeBag)

        mainView.authInputView.textField.rx.text.orEmpty
            .asDriver()
            .drive(viewModel.input.textFieldText)
            .disposed(by: disposeBag)

        mainView.authInputView.textField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(viewModel.input.tapPhoneNumberTextField)
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
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.pushToLoginViewController()
            }
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, errorText in
                owner.view.makeToast(errorText)
            }
            .disposed(by: disposeBag)

        viewModel.output.textFieldState
            .asDriver(onErrorJustReturn: .inActive)
            .drive(mainView.authInputView.rx.textFieldState)
            .disposed(by: disposeBag)

        textFieldText
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.authInputView.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func pushToLoginViewController() {
        print("push")
        let vc = LogInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("===RequestAuthViewController deinit===")
    }
}

