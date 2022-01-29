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
                owner.printUserInfo()
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
