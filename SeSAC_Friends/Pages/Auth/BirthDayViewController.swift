//
//  BirthDayViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import UIKit
import RxSwift

class BirthDayViewController: UIViewController {
    //MARK: Properties
    var disposeBag = DisposeBag()
    let viewModel = BirthViewModel()
    
    //MARK: UI
    let mainView = AuthView(state: .birthDay)
    
    //MARK: Method
    
    func bind() {
        mainView.datePicker.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(viewModel.input.valueChanged)
            .disposed(by: disposeBag)

        mainView.datePicker.rx.date
            .asDriver()
            .drive(viewModel.input.selectedDate)
            .disposed(by: disposeBag)
        
        mainView.authRequestButton.rx.tap
            .asDriver()
            .drive(viewModel.input.tapConfirmButton)
            .disposed(by: disposeBag)
        
        viewModel.output.yearText
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.authInputView.yearTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.monthText
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.authInputView.monthTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.dayText
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.authInputView.dayTextField.rx.text)
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
        
        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.view.makeToast(message)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.goToEmailView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = EmailViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
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
        if !(UserInfo.birthday.isEmpty) {
            mainView.datePicker.date = DateManager.shared.stringToDate(dateFormat: UserInfo.birthday)
            viewModel.input.selectedDate.onNext(mainView.datePicker.date)
            viewModel.input.valueChanged.onNext(())
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
