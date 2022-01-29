//
//  NickNameViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import UIKit
import RxSwift
import RxCocoa
import Toast
import Firebase


enum NickNameViewState {
    case normal
    case error
}

class NickNameViewController: UIViewController {
    //MARK: Properties
    
    let viewModel = NickNameViewModel()
    
    var disposeBag = DisposeBag()
    
    var state: NickNameViewState = .normal
    
    //MARK: UI
    
    let mainView = AuthView(state: .nickName)
    
    //MARK: Method
    
    func bind() {
        let textFieldText = mainView.authInputView.textField.rx.text.orEmpty
            .share()
        
        mainView.authInputView.textField.rx.controlEvent(.editingDidBegin)
            .bind(to: viewModel.input.tapTextField)
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
        
        textFieldText
            .asDriver(onErrorJustReturn: "")
            .drive(viewModel.input.textFieldText)
            .disposed(by: disposeBag)
        
        mainView.authRequestButton.rx.tap
            .asDriver()
            .drive(viewModel.input.tapConfirmButton)
            .disposed(by: disposeBag)
        
        viewModel.output.textFieldState
            .asDriver()
            .drive(mainView.authInputView.rx.textFieldState)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, errorText in
                owner.view.makeToast(errorText)
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

        viewModel.output.goToBirthdayView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = BirthDayViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

    }
    
    func whenNicknameIsError() {
        if state == .error {
            viewModel.output.textFieldState.accept(.error)
            view.makeToast(APIError.invalidNickname.rawValue, duration: 3, position: .center)
            mainView.authInputView.errorLabel.text = APIError.invalidNickname.rawValue
        }
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
        if !(UserInfo.nickname.isEmpty) {
            mainView.authInputView.textField.text = UserInfo.nickname
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.authInputView.textField.becomeFirstResponder()
        whenNicknameIsError()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    deinit {
        print("===\(self) Deinit===")
    }
}
