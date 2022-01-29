//
//  GenderViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/27.
//

import UIKit
import RxSwift
import Toast

class GenderViewController: UIViewController {
    //MARK: Properties
    
    var disposeBag = DisposeBag()
    let viewModel = GenderViewModel()
    
    //MARK: UI
    let mainView = AuthView(state: .gender)
    
    
    //MARK: Method
    private func bind() {
        mainView.authInputView.manButton.rx.tap
            .asDriver()
            .drive(viewModel.input.manButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.authInputView.womanButton.rx.tap
            .asDriver()
            .drive(viewModel.input.womanButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.authRequestButton.rx.tap
            .asDriver()
            .drive(viewModel.input.confirmButtonClicked)
            .disposed(by: disposeBag)
        
        viewModel.output.manButtonState
            .asDriver()
            .drive(mainView.authInputView.manButton.rx.isClicked)
            .disposed(by: disposeBag)
        
        viewModel.output.womanButtonState
            .asDriver()
            .drive(mainView.authInputView.womanButton.rx.isClicked)
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
        
        viewModel.output.goToHome
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = HomeViewController()
                owner.changeRootView(viewController: vc)
            }
            .disposed(by: disposeBag)

        viewModel.output.goToNickName
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                guard let vcs = owner.navigationController?.viewControllers else { return }
                for vc in vcs {
                    if let nickVC = vc as? NickNameViewController {
                        nickVC.state = .error
                        owner.navigationController?.popToViewController(nickVC, animated: true)
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
        self.printUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind()
        if UserInfo.gender == 1 {
            viewModel.input.manButtonClicked.onNext(())
            viewModel.output.isButtonEnable.accept(true)
        } else if UserInfo.gender == 0 {
            viewModel.input.womanButtonClicked.onNext(())
            viewModel.output.isButtonEnable.accept(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
